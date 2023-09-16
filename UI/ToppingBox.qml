import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    property string toppings: ""

    ComboBox {
        id: comboboxId
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
            height: parent.width
            Row {
                anchors.fill: parent
                anchors.margins: parent.width / 8
                spacing: parent.width / 200
                CheckBox {
                    id: checkboxId
                    anchors.verticalCenter: parent.verticalCenter
                    onCheckedChanged: {
                        if (checked) {
                            toppings += model.name + " "
                        } else {
                            toppings = toppings.replace(model.name + " ", "")
                        }
                        comboboxId.currentText = ""
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
