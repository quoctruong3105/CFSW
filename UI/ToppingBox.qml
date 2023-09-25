import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    property var add: ({})

    ComboBox {
        id: comboBox
        width: parent.width
        height: parent.height
        model: models.toppingModel
        Text {
            text: qsTr("Add...")
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: parent.width / 10
            font.pointSize: drinkName.font.pointSize
        }
        delegate: Item {
            width: parent.width
            height: parent.width / 1.5
            Row {
                anchors.fill: parent
                anchors.margins: parent.width / 8
                spacing: parent.width / 200
                CheckBox {
                    id: checkboxId
                    anchors.verticalCenter: parent.verticalCenter
                    onCheckedChanged: {
                        if (checked) {
                            add[model.topping] = model.cost;
                        } else {
                            if (add.hasOwnProperty(model.topping)) {
                                delete add[model.topping];
                            }
                        }
                        for(var i = 0; i < models.selectModel.count; i++) {
                            if(models.selectModel.get(i).drink === drinkName.text
                               && models.selectModel.get(i).index === item.index) {
                                models.selectModel.setProperty(i, "add", add)
                                var totalToppingCostValue = 0
                                for (var key in add) {
                                    if (add.hasOwnProperty(key)) {
                                        var value = add[key];
                                        totalToppingCostValue += value
                                    }
                                }
                                models.selectModel.setProperty(i, "extraCost", totalToppingCostValue)
                                billView.updateTotal()
                                break
                            }
                        }
                    }
                }
                Label {
                    text: model.topping
                    width: parent.width - checkboxId.width
                    height: parent.height
                    verticalAlignment: Qt.AlignVCenter
                }
            }
        }
    }
}
