import QtQuick 2.15
import QtQuick.Controls 2.15


Item {
    property alias drinkModel: drinkModel
    property alias cakeModel: cakeModel

    function dummyData() {
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

    Component.onCompleted: {
        core.dh.exeQuery("")
        dummyData()
    }
}
