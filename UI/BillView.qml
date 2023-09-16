import QtQuick 2.15
import QtQuick.Controls

Item {
    property int totalCostValue
    property int totalQualtityValue

    function updateTime() {
        var now = new Date();
        var day = ("0" + now.getDate()).slice(-2);
        var month = ("0" + (now.getMonth() + 1)).slice(-2);
        var year = now.getFullYear();
        var hours = ("0" + now.getHours()).slice(-2);
        var minutes = ("0" + now.getMinutes()).slice(-2);

        dateTime.text = "Ngày tạo: " + day + "/" + month + "/" + year + " " + hours + ":" + minutes;
    }


    function updateTotal() {
        totalCostValue = 0
        for(var i = 0; i < models.selectModel.count; ++i) {
            totalCostValue += (models.selectModel.get(i).cost + models.selectModel.get(i).extraCost) * models.selectModel.get(i).qualtity
        }
        totalQualtityValue = 0
        for(var j = 0; j < models.selectModel.count; ++j) {
            totalQualtityValue += models.selectModel.get(j).qualtity
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: updateTime()
    }

    Component.onCompleted: updateTime()

    width: parent.width - menuView.width
    height: parent.height
    Rectangle {
        id: billBackGround
        width: parent.width
        height: parent.height
        color: root.defaultColor
        Rectangle {
            width: mainBill.width
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
                bottom: mainBill.top
            }

            Rectangle {
                id: swIcon
                height: parent.height / 1.2
                width: height / 1.5
                color: "transparent"
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                Image {
                    anchors.fill: parent
                    source: "qrc:/img/app_icon.ico"
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: loginPage.isValid = false
                }
            }
        }

        Rectangle {
            id: mainBill
            width: parent.width / 1.05
            height: parent.height / 1.05
            anchors {
                bottom: parent.bottom
                horizontalCenter: parent.horizontalCenter
            }
            Rectangle {
                id: billHeader
                width: parent.width
                height: parent.height / 15
                color: "lightgrey"

                Text {
                    anchors.fill: parent
                    text: qsTr("Thông tin")
                    font.pointSize: parent.height / 3
                }
            }
            Rectangle {
                id: dateTimeContainer
                width: itemSelection.width
                height: billHeader.height / 1.2
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    top: billHeader.bottom
                }
                Text {
                    id: dateTime
                    x: payBtn.x
                    anchors {
                        verticalCenter: parent.verticalCenter
                    }
                    font.pointSize: parent.height / 3.75
                }
                Text {
                    id: creater
                    text: "Người tạo:  "
                    anchors {
                        left: dateTime.right
                        leftMargin: dateTime.height * 2
                        verticalCenter: parent.verticalCenter
                    }
                    font.pointSize: dateTime.font.pointSize
                }
                ComboBox {
                    font.pointSize: dateTime.font.pointSize
                    anchors {
                        left: creater.right
                        verticalCenter: parent.verticalCenter
                    }
                    model: ["admin 1", "admin 2", "admin 3"]
                }
            }
            Rectangle {
                id: itemSelection
                width: parent.width / 1.05
                height: billHeader.height * 10
                border {
                    color: "lightgrey"
                    width: dateTimeContainer.height / 20
                }
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    top: dateTimeContainer.bottom
                }
                Flickable {
                    width: parent.width / 1.05
                    height: parent.height / 1.05
                    anchors.centerIn: parent
                    ListView {
                        id: itemListView
                        width: itemSelection.width - itemSelection.border.width * 2
                        height: itemSelection.height - itemSelection.border.width * 2
                        anchors.centerIn: parent
                        clip: true
                        model: models.selectModel

                        delegate: Rectangle {
                            id: item
                            height: billHeader.height
                            width: parent.width
                            anchors.horizontalCenter: parent.horizontalCenter                           
                            property int index: model.index
                            Rectangle {
                                id: removeContainer
                                height: parent.height
                                width: parent.width * 1 / 10
                                anchors.left: parent.left
                                anchors.margins: width / 20
                                color: "transparent"
                                Text {
                                    id: removeBtn
                                    text: "X"
                                    font.bold: true
                                    font.pointSize: parent.height / 3
                                    anchors.centerIn: parent
                                    color: "red"
                                }
                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        for(var i = 0; i < models.selectModel.count; i++) {
                                            if(models.selectModel.get(i).drink === drinkName.text &&
                                            models.selectModel.get(i).index === item.index) {
                                                models.selectModel.remove(i)
                                                break
                                            }
                                        }
                                    }
                                }
                            }
                            Rectangle {
                                id: drinkNameContainer
                                height: parent.height
                                width: parent.width * 8 / 25
                                clip: true
                                color: "transparent"
                                anchors.left: removeContainer.right
                                Text {
                                    id: drinkName
                                    text: model.drink
                                    font.pointSize: parent.height / 5
                                    anchors {
                                        verticalCenter: parent.verticalCenter
                                    }
                                }
                            }
                            Rectangle {
                                id: toppingContainer
                                width: factorContainer.width * 2
                                height: factorContainer.height
                                anchors.left: drinkNameContainer.right
                                ToppingBox {
                                    id: extraTopping
                                    width: factor.width * 1.2
                                    height: factor.height
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                            }
                            Rectangle {
                                id: factorContainer
                                height: parent.height
                                width: parent.width * 2 / 15
                                color: "transparent"
                                anchors.left: toppingContainer.right
                                anchors.leftMargin: width / 6.5
                                QualtityBox {
                                    id: factor
                                    height: parent.height * 2 / 3
                                    width: parent.width
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                            }
                            Rectangle {
                                id: costContainer
                                height: parent.height
                                width:  factor.width
                                color: "transparent"
                                anchors.right: parent.right
                                Text {
                                    id: cost
                                    text: (model.cost + model.extraCost) * factor.value + ".000"
                                    font.pointSize: drinkName.font.pointSize / 1.05
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }
                            }
                        }
                    }
                }
            }
            Rectangle {
                id: payContainer
                width: itemSelection.width
                height: billHeader.height * 1.5
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    top: itemSelection.bottom
                }
                Rectangle {
                    id: payBtn
                    width: parent.width / 4
                    height: parent.height / 1.5
                    color: "limegreen"
                    anchors.verticalCenter: parent.verticalCenter
                    Text {
                        text: qsTr("YÊU CẦU \nTHANH TOÁN")
                        color: "white"
                        horizontalAlignment: Text.AlignHCenter
                        anchors.centerIn: parent
                        font {
                            bold: true
                            pointSize: payContainer.height / 8
                        }
                    }
                }
                Rectangle {
                    width: parent.width / 4
                    height: parent.height / 1.5
                    anchors {
                        left: payBtn.right
                        leftMargin: payBtn.width / 5
                        verticalCenter: parent.verticalCenter
                    }
                    Text {
                        text: qsTr("Tổng số lượng hàng")
                        font.pointSize: dateTime.font.pointSize
                        anchors.top: parent.top
                    }
                    Text {
                        text: qsTr("Tổng tiền hàng")
                        font.pointSize: dateTime.font.pointSize
                        anchors.bottom: parent.bottom
                    }
                }
                Rectangle {
                    width: parent.width / 8
                    height: parent.height / 1.5
                    anchors {
                        right: parent.right
                        leftMargin: dateTime.font.pointSize
                        verticalCenter: parent.verticalCenter
                    }
                    Text {
                        id: totalQualtity
                        text: totalQualtityValue
                        font.pointSize: dateTime.font.pointSize
                        anchors.top: parent.top
                        anchors.right: parent.right
                    }
                    Text {
                        id: totalCost
                        text: totalCostValue + ".000"
                        font.pointSize: dateTime.font.pointSize
                        anchors.bottom: parent.bottom
                        anchors.right: parent.right
                    }
                }
            }
        }
    }
}
