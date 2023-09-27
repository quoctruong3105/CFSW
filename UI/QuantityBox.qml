import QtQuick 2.15
import QtQuick.Controls

Item {
    property alias value: spinBox.text

    function incrementSpinBox() {
        var currentValue = parseInt(spinBox.text)
        if (currentValue < 100) {
            spinBox.text = (currentValue + 1).toString()
        }
    }

    function decrementSpinBox() {
        var currentValue = parseInt(spinBox.text)
        if (currentValue > 1) {
            spinBox.text = (currentValue - 1).toString()
        }
    }

    Rectangle {
        width: parent.width
        height: parent.height
        Rectangle {
            id: spinBoxContainer
            width: parent.width * 1.2 / 5
            height: parent.height
            border.color: "lightgrey"
            anchors.centerIn: parent
            Text {
                id: spinBox
                anchors.centerIn: parent
                text: "1"
                font.pointSize: drinkName.font.pointSize
                onTextChanged: {
                    for(var i = 0; i < models.selectModel.count; ++i) {
                        if(models.selectModel.get(i).index === item.index) {
                            models.selectModel.setProperty(i, "quantity", factor.value)
                            billView.updateTotal()
                            break
                        }
                    }
                }
            }
        }

        Button {
            text: "+"
            font.pointSize: spinBox.font.pointSize
            font.bold: true
            width: parent.width * 1.2 / 5
            height: parent.height
            anchors.verticalCenter: spinBoxContainer.verticalCenter
            anchors.left: spinBoxContainer.right
            onClicked: incrementSpinBox()
        }

        Button {
            text: "-"
            font.pointSize: spinBox.font.pointSize
            font.bold: true
            width: parent.width * 1.2 / 5
            height: parent.height
            anchors.verticalCenter: spinBoxContainer.verticalCenter
            anchors.right: spinBoxContainer.left
            onClicked: decrementSpinBox()
        }

    }
}
