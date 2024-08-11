import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    property alias searchTxt: searchTxt
    property bool preResultValid: true

    Timer {
        id: delayTimer
        interval: 200
        running: false
        onTriggered: {
            busyIndicator.running = false
            core.dh.queryItem(searchTxt.text, 0, "drinks")
            models.dummyData(models.drinkModel)
        }
    }

    BusyIndicator {
        id: busyIndicator
        width: eraserBtn.width * 3
        height: width
        y : (menuView.stackView.height) / 3
        anchors.horizontalCenter: parent.horizontalCenter
        visible: true
        running: false
    }

    Rectangle {
        id: searchField
        width: parent.width
        height: parent.height
        TextField {
            id: searchTxt
            placeholderText: "Nhập tên hàng hóa"
            font.pixelSize: searchField.height / 1.5
            anchors {
                fill: parent
                verticalCenter: containBar.verticalCenter
            }
            onTextEdited: {
                if(menuView.stackView.currentItem == menuView.drinkPage) {
                    if(models.drinkModel.count !== 0) {
                        models.drinkModel.clear()
                    }
                    delayTimer.restart()
                    busyIndicator.running = true
                    if(menuView.drinkPageContent.catigory.currentIndex != 0) {
                        menuView.drinkPageContent.catigory.currentIndex = 0
                    }
                }
            }
        }
        Rectangle {
            id: eraserBtn
            width: searchField.height
            height: width
            smooth: true
            antialiasing: true

            Text {
                id: searchText
                text: qsTr("⌫")
                font {
                    bold: true
                    pointSize: parent.height / 2
                }
                color: "red"
                anchors.centerIn: parent
                scale: 1
            }

            anchors {
                left: searchField.right
                top: searchField.top
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    searchTxt.text = ""
                    scaleAnimator(searchText)
                    if(menuView.stackView.currentItem == menuView.drinkPage) {
                        models.drinkModel.clear()
                        core.dh.queryItem("", 0, "drinks")
                        models.dummyData(models.drinkModel)
                        if(menuView.drinkPageContent.catigory.currentIndex != 0) {
                            menuView.drinkPageContent.catigory.currentIndex = 0
                        }
                    }
                }
            }
        }
    }
}
