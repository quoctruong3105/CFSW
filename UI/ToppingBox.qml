import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    property var add: ({})

    ComboBox {
        id: comboBox
        width: parent.width
        height: parent.height / 1.2
        anchors.verticalCenter: parent.verticalCenter
        model: models.toppingModel
        popup{
            width: parent.width * 2.5
            topPadding: {
                if (contentItem && contentItem.height > billView.height)
                    return -parent.height + contentItem.height;
                else
                    return 0;
            }
        }
        Text {
            text: qsTr("Extra...")
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: parent.width / 10
            font.pointSize: drinkName.font.pointSize
        }
        delegate: Item {
            width: parent.width
            height: parent.width / 3
            Row {
                anchors.fill: parent
                anchors.margins: parent.width / 8
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
                            if(/*models.selectModel.get(i).drink === drinkName.text
                               &&*/ models.selectModel.get(i).index === item.index) {
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
                    width: parent.width - checkboxId.width
                    height: parent.height
                    verticalAlignment: Qt.AlignVCenter
                    Text {
                        text: model.topping
                        font.pointSize: parent.width / 9
                        width: parent.width
                        elide: Text.ElideRight // This will truncate the text with "..." if it overflows
                    }
                }
            }
        }
    }
}
