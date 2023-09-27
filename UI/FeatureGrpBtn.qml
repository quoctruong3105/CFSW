import QtQuick 2.15
import QtQuick.Layouts 2.15

Item {
    property color normalColor: "white"
    property color chooseColor: "black"
    property var listBtn: [findBillBtn, refreshBillBtn, logOutBtn]

    Component.onCompleted: {
        // Handle for log out
        dialogs.logOutDialog.accepted.connect(function() {
            core.dh.updateAccLog(false, billView.currentTime.text, core.currentAcc.getCurrentUser())
            loginPage.isValid = false
            resetToNormal()

        })
        dialogs.logOutDialog.rejected.connect(function() {
            resetToNormal()
        })

        // Handle for refresh bill
        dialogs.refreshBillDialog.accepted.connect(function() {
            core.billGen.clearListItem()
            models.selectModel.clear()
            billView.cardNo.text = "0"
            resetToNormal()
        })
        dialogs.refreshBillDialog.rejected.connect(function() {
            resetToNormal()
        })

        // Handle for find bill
        dialogs.findBillDialog.closed.connect(function() {
            resetToNormal()
        })
    }

    function resetToNormal() {
        for(var i = 0; i < listBtn.length; ++i) {
            if(listBtn[i].color === chooseColor) {
                listBtn[i].color = normalColor
                break
            }
        }
    }

    function openDialogAtCenter(dialogName) {
        var dialogWidth = dialogName.width;
        var dialogHeight = dialogName.height;

        dialogName.x = (menuView.stackView.width - dialogWidth) / 2;
        dialogName.y = (menuView.stackView.height - dialogHeight) / 2;
        dialogName.open()
    }

    function callDialog(btnId) {
        resetToNormal()
        btnId.color = chooseColor
        if(btnId === logOutBtn) {
            openDialogAtCenter(dialogs.logOutDialog)
        } else if(btnId === refreshBillBtn) {
            openDialogAtCenter(dialogs.refreshBillDialog)
        } else if(btnId === findBillBtn) {
            openDialogAtCenter(dialogs.findBillDialog)
        }
    }

    Rectangle {
        id: findBillBtn
        height: parent.height / 1.2
        width: parent.width / 7
        radius: height / 2
        anchors {
            right: refreshBillBtn.left
            rightMargin: width / 5
            verticalCenter: parent.verticalCenter
        }
        antialiasing: true
        Text {
            text: qsTr("Find \nBill")
            color: "dodgerblue"
            font.pointSize: parent.height / 4
            font.bold: true
            anchors.centerIn: parent
            horizontalAlignment: Text.AlignHCenter
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                callDialog(findBillBtn)
            }
        }
    }
    Rectangle {
        id: refreshBillBtn
        height: parent.height / 1.2
        width: parent.width / 7
        radius: height / 2
        anchors {
            right: logOutBtn.left
            rightMargin: width / 5
            verticalCenter: parent.verticalCenter
        }
        antialiasing: true
        Text {
            text: qsTr("Refresh \nBill")
            color: "lightseagreen"
            font.bold: true
            font.pointSize: parent.height / 4
            anchors.centerIn: parent
            horizontalAlignment: Text.AlignHCenter
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                callDialog(refreshBillBtn)
            }
        }
    }
    Rectangle {
        id: logOutBtn
        height: parent.height / 1.2
        width: parent.width / 7
        radius: height / 2
        anchors {
            right: parent.right
            rightMargin: width / 10
            verticalCenter: parent.verticalCenter
        }
        antialiasing: true
        Text {
            text: qsTr("Log \nOut")
            color: "red"
            font.bold: true
            font.pointSize: parent.height / 4
            anchors.centerIn: parent
            horizontalAlignment: Text.AlignHCenter
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                callDialog(logOutBtn)
            }
        }
    }
}
