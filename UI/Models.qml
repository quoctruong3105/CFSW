import QtQuick 2.15
import QtQuick.Controls 2.15


Item {
    property alias drinkModel: drinkModel
    property alias cakeModel: cakeModel
    property alias selectModel: selectModel

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
        core.dh.exeQuery("")
        dummyData()
    }

    function dummyData() {
        drinkModel.clear()
        for (var i = 0; i < core.dh.getDrinkListLength(); ++i) {
            drinkModel.append(core.dh.getDrinkList(i));
        }
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
}
