import QtQuick 2.15
import QtQuick.Controls 2.15


Item {
    property alias drinkModel: drinkModel
    property alias cakeModel: cakeModel
    property alias selectModel: selectModel
    property alias toppingModel: toppingModel
    property var tableList: ["drinks", "toppings"]

    function updateTotal() {
        var totalCost = 0
        var totalQualtity = 0
        for(var i = 0; i < selectModel.count; i++) {
            var costString = selectModel.get(i).cost;
            totalQualtity +=  selectModel.get(i).qualtity
            var costValue = parseFloat(costString.slice(0, costString.length - 4)) * selectModel.get(i).qualtity

            if (!isNaN(costValue)) {
                totalCost += costValue;
            }
        }
        billView.totalCost = totalCost + ".000"
        billView.totalQualtity = totalQualtity
    }

    Component.onCompleted: {
        for (var i = 0; i < tableList.length; ++i) {
            var tableName = tableList[i];
            var modelName
            core.dh.exeQuery("", tableName)
            if(tableName === "drinks") {
                modelName = drinkModel
            } else if(tableName === "toppings") {
                modelName = toppingModel
            } else {
                modelName = cakeModel
            }
            dummyData(modelName);
        }
    }

    function dummyData(model) {
        for (var i = 0; i < core.dh.getItemListLength(); ++i) {
            model.append(core.dh.getItemList(i));
        }
        core.dh.clearData()
    }

    ListModel {
        id: drinkModel
    }
    ListModel {
        id: cakeModel
    }
    ListModel {
        id: selectModel
        onCountChanged: updateTotal()
    }
    ListModel {
        id: toppingModel
    }
}
