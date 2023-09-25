import QtQuick 2.15
import QtQuick.Controls 2.15


Item {
    property alias drinkModel: drinkModel
    property alias cakeModel: cakeModel
    property alias selectModel: selectModel
    property alias toppingModel: toppingModel
    property alias accModel: accModel
    property var tableList: ["drinks", "toppings", "accounts"]

    function dummyData(model) {
        for (var i = 0; i < core.dh.getItemListLength(); ++i) {
            model.append(core.dh.getItemList(i));
        }
        core.dh.clearData()
    }

    Component.onCompleted: {
        for (var i = 0; i < tableList.length; ++i) {
            var tableName = tableList[i];
            var modelName
            core.dh.queryItem("", tableName)
            if(tableName === "drinks") {
                modelName = drinkModel
            } else if(tableName === "toppings") {
                modelName = toppingModel
            } else if(tableName === "cakes"){
                modelName = cakeModel
            } else if(tableName === "accounts"){
                modelName = accModel
            }
            dummyData(modelName);
        }
    }


    ListModel {
        id: accModel
    }
    ListModel {
        id: drinkModel
    }
    ListModel {
        id: cakeModel
    }
    ListModel {
        id: toppingModel
    }
    ListModel {
        id: selectModel
        onCountChanged: {
            core.billGen.clearListItem()
            billView.updateTotal()
            for(var i = 0; i < selectModel.count; i++) {
                selectModel.setProperty(i, "index", i + 1)
            }
        }
    }
}
