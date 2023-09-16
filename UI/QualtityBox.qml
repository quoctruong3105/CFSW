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
            width: parent.width / 2
            height: parent.height
            border.color: "lightgrey"
            Text {
                id: spinBox
                anchors.centerIn: parent
                text: "1"
                font.pointSize: drinkName.font.pointSize
                onTextChanged: {
                    for(var i = 0; i < models.selectModel.count; ++i) {
                        if(models.selectModel.get(i).drink === drinkName.text) {
                            models.selectModel.setProperty(i, "qualtity", factor.value)
                            models.updateTotal()
                        }
                    }
                }
            }
        }

        Button {
            text: "+"
            font.pointSize: spinBox.font.pointSize
            font.bold: true
            width: parent.width / 2.5
            height: parent.height
            anchors.verticalCenter: spinBoxContainer.verticalCenter
            anchors.right: spinBoxContainer.left
            onClicked: incrementSpinBox()
        }

        Button {
            text: "-"
            font.pointSize: spinBox.font.pointSize
            font.bold: true
            width: parent.width / 2.5
            height: parent.height
            anchors.verticalCenter: spinBoxContainer.verticalCenter
            anchors.left: spinBoxContainer.right
            onClicked: decrementSpinBox()
        }

    }
}
