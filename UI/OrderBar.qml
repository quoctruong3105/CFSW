import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    property color onClickedCoor: root.defaultColor
    property color defaultColor: "#BBA68B"

    function updateBtn(nameOn, nameOff) {
        menuView.stackView.clear()
        nameOff.color = defaultColor
        nameOn.color = onClickedCoor
        if(nameOn === drinkBtnId) {
            menuView.stackView.push(menuView.drinkPage)
        } else {
            menuView.stackView.push(menuView.cakePage)
        }
    }

    Component.onCompleted: {
        menuView.stackView.push(menuView.drinkPage)
        cakeBtnId.color = defaultColor
        drinkBtnId.color = onClickedCoor
    }

    Column {
        width: parent.width
        height: parent.height
        Rectangle {
            id: drinkBtnId
            height: parent.height
            width: parent.width / 2
            color: "lightgrey"
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: cakeBtnId.left
            anchors.rightMargin: parent.height / 10
            Text {
                text: qsTr("DRINK")
                font.bold: true
                font.family: "Arial"
                anchors.centerIn: parent
                font.pointSize: drinkBtnId.width / 6
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    updateBtn(drinkBtnId, cakeBtnId)
                }
            }
        }
        Rectangle {
            id: cakeBtnId
            height: parent.height
            width: parent.width / 2
            color: "lightgrey"
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.rightMargin: parent.height / 10
            Text {
                text: qsTr("CAKE")
                font.bold: true
                font.family: "Arial"
                anchors.centerIn: parent
                font.pointSize: drinkBtnId.width / 6
            }
            MouseArea {
                anchors.fill: parent
                onClicked: updateBtn(cakeBtnId, drinkBtnId)
            }
        }
    }
}
