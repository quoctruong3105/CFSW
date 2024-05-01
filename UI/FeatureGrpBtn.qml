import QtQuick 2.15
import QtQuick.Layouts 2.15

Item {
    property color normalColor: "white"
    property color chooseColor: "black"
    property alias findBillBtn: findBillBtn
    property alias refreshBillBtn: refreshBillBtn
    property alias logOutBtn: logOutBtn
    property var listBtn: [findBillBtn, refreshBillBtn, logOutBtn]

    function resetAllToNormal() {
        for(var i = 0; i < featureBtnGrp.listBtn.length; ++i) {
            if(featureBtnGrp.listBtn[i].color === featureBtnGrp.chooseColor) {
                featureBtnGrp.listBtn[i].color = featureBtnGrp.normalColor
                break
            }
        }
    }

    // Waiting
//    Rectangle {
//        id: noName1
//        height: parent.height / 1.2
//        width: parent.width / 6
//        radius: height / 2
//        anchors {
//            right: noName.left
//            rightMargin: width / 5
//            verticalCenter: parent.verticalCenter
//        }
//        antialiasing: true
//        Text {
//            text: qsTr("")
//            color: "dodgerblue"
//            font.pointSize: parent.height / 4
//            font.bold: true
//            anchors.centerIn: parent
//            horizontalAlignment: Text.AlignHCenter
//        }
//        MouseArea {
//            anchors.fill: parent
//            onClicked: {
//                //dialogs.callDialog(findBillBtn)
//            }
//        }
//    }


    Rectangle {
        id: eventInfoBtn
        height: parent.height / 1.2
        width: parent.width / 6
        radius: height / 2
        anchors {
            right: findBillBtn.left
            rightMargin: width / 5
            verticalCenter: parent.verticalCenter
        }
        antialiasing: true
        Text {
            text: qsTr("Event \n📰")
            color: "dimgray"
            font.pointSize: parent.height / 4
            font.bold: true
            anchors.centerIn: parent
            horizontalAlignment: Text.AlignHCenter
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
            }
        }
    }

    Rectangle {
        id: findBillBtn
        height: parent.height / 1.2
        width: parent.width / 6
        radius: height / 2
        anchors {
            right: refreshBillBtn.left
            rightMargin: width / 5
            verticalCenter: parent.verticalCenter
        }
        antialiasing: true
        Text {
            text: qsTr("Find Bill \n🔎")
            color: "dodgerblue"
            font.pointSize: parent.height / 4
            font.bold: true
            anchors.centerIn: parent
            horizontalAlignment: Text.AlignHCenter
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                dialogs.callDialog(findBillBtn)
            }
        }
    }
    Rectangle {
        id: refreshBillBtn
        height: parent.height / 1.2
        width: parent.width / 6
        radius: height / 2
        anchors {
            right: logOutBtn.left
            rightMargin: width / 5
            verticalCenter: parent.verticalCenter
        }
        antialiasing: true
        Text {
            text: qsTr("Clean Bill \n🧹")
            color: "red"
            font.bold: true
            font.pointSize: parent.height / 4
            anchors.centerIn: parent
            horizontalAlignment: Text.AlignHCenter
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                dialogs.callDialog(refreshBillBtn)
            }
        }
    }
    Rectangle {
        id: logOutBtn
        height: parent.height / 1.2
        width: parent.width / 6
        radius: height / 2
        anchors {
            right: parent.right
            rightMargin: width / 10
            verticalCenter: parent.verticalCenter
        }
        antialiasing: true
        Text {
            text: qsTr("Log Out \n🚪")
            color: "peru"
            font.bold: true
            font.pointSize: parent.height / 4
            anchors.centerIn: parent
            horizontalAlignment: Text.AlignHCenter
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                dialogs.callDialog(logOutBtn)
            }
        }
    }
}
