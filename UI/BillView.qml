import QtQuick 2.15
import QtQuick.Controls

Item {
    width: parent.width - menuView.width
    height: parent.height
    Rectangle {
        id: billBackGround
        width: parent.width
        height: parent.height
        color: root.defaultColor
        Rectangle {
            width: bill.width
            height: parent.height / 20
            color: "transparent"
            Text {
                text: qsTr("HÓA ĐƠN")
                font.bold: true
                font.pointSize: parent.height / 2.5
                anchors.top: parent.top
            }
            anchors{
                horizontalCenter: parent.horizontalCenter
                bottom: bill.top
            }
        }

        Rectangle {
            id: bill
            width: parent.width / 1.05
            height: parent.height / 1.05
            anchors {
                bottom: parent.bottom
                horizontalCenter: parent.horizontalCenter
            }
        }
    }
}
