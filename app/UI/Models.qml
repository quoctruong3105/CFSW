import QtQuick 2.15
import QtQuick.Controls 2.15


Item {
    property alias drinkModel: drinkModel
    property alias cakeModel: cakeModel
    property alias selectModel: selectModel
    property alias toppingModel: toppingModel
    property alias accModel: accModel
    property alias billModel: billModel
    property alias discountModel: discountModel
    property var tableList: ["drinks", "cakes", "toppings", "accounts"]

    function dummyData(model) {
        for (var i = 0; i < core.dh.getItemListLength(); ++i) {
            model.append(core.dh.getItemList(i))
            if(model === drinkModel) {
                if(menuView.drinkPageContent.initial == true) {
                    menuView.drinkPageContent.initial = false
                }
                model.setProperty(i, "state", core.inventory.getDrinkState(model.get(i).drink, 0))
            }
        }
        core.dh.clearData()
    }

    // Convert ListModel to QList<QVariantMap> used in C++
    function convertListModelToArr(model) {
        var arr = []
        for(var i = 0; i < model.count; ++i) {
            var mp = {}
            for(var key in model.get(i)) {
                mp[key] = model.get(i)[key]
            }
            arr.push(mp)
        }
        return arr
    }

    ListModel {
        id: accModel
    }

    ListModel {
        id: drinkModel

        function refreshDrinkState() {
            // Re-fetch data from Inventory and show new drink state
            core.inventory.fetchMaterial()
            for(var i = 0; i < drinkModel.count; ++i) {
                drinkModel.setProperty(i, "state", core.inventory.getDrinkState(drinkModel.get(i).drink, 0))
            }
        }
    }

    ListModel {
        id: cakeModel
    }

    ListModel {
        id: toppingModel
    }

    ListModel {
        id: billModel

        function dummyBillInfo(text) {
            if(billModel.count == 1) {
                billModel.remove(0)
            }
            billModel.append(core.dh.queryBill(text))
        }
    }

    ListModel {
        id: discountModel

        function checkDiscount() {
            discountModel.clear()
            if(core.discount.getListDiscountItem(convertListModelToArr(selectModel)).length !== 0) {
                var tmpList = []
                tmpList = core.discount.getListDiscountItem(convertListModelToArr(selectModel))
                for(var j = 0; j < tmpList.length; ++j) {
                    discountModel.append(tmpList[j])
                    //console.log(discountModel.get(j).discountValue)
                }
            }
        }
    }

//    ListModel {
//        id: discountContent

//        function getDiscountContent() {
//            for(var i = 0; i < core.discount.getDiscountVectLength(); ++i) {
//                discountContent.append(core.discount.getDiscountContent(i))
//            }
//        }

//        Component.onCompleted: getDiscountContent()
//    }

    ListModel {
        id: selectModel
        onCountChanged: {
            billView.updateTotal()
            for(var i = 0; i < selectModel.count; i++) {
                selectModel.setProperty(i, "index", i + 1)
            }
            discountModel.checkDiscount()
        }
    }

    Component.onCompleted: {
        for (var i = 0; i < tableList.length; ++i) {
            var tableName = tableList[i];
            var modelName
            core.dh.queryItem("", 0, tableName)
            if(tableName === "drinks") {
                modelName = drinkModel
            } else if(tableName === "toppings") {
                modelName = toppingModel
            } else if(tableName === "cakes"){
                modelName = cakeModel
            } else if(tableName === "accounts"){
                modelName = accModel
            }
            dummyData(modelName)
        }
    }
}
