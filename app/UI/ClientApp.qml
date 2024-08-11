import QtQuick 2.15
import QtQuick.Controls 2.15

ApplicationWindow {
    id: clientApp
    visible:  true
    width: Screen.width / 2
    height: Screen.height / 2
    //visibility: Window.FullScreen
    x: Qt.application.screens[targetScreenIndex].virtualX
    y: Qt.application.screens[targetScreenIndex].virtualY
    property int targetScreenIndex: (hasMoreThanOneMonitor()) ? 0 : 1
    property alias qrCodeImg: qrCodeImg

    function hasMoreThanOneMonitor() {
        return Qt.application.screens.length > 1
    }

    onClosing: {
        Qt.quit()
    }

    Rectangle {
        width: parent.width
        height: parent.height
        color: "white"
        Rectangle {
            id: billBackGround
            width: parent.width / 2
            height: parent.height
            color: root.defaultColor

            Rectangle {
                id: mainBill
                width: parent.width / 1.05
                height: parent.height
                anchors {
                    top: parent.top
                    horizontalCenter: parent.horizontalCenter
                }
                Rectangle {
                    id: billHeader
                    width: parent.width
                    height: parent.height / 20
                    color: defaultColor

                    Text {
                        id: billHeadTxt
                        text: qsTr("QUÝ KHÁCH VUI LÒNG KIỂM TRA HÓA ĐƠN")
                        font.bold: true
                        font.pointSize: parent.height / 3
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
                Rectangle {
                    id: itemSelection
                    width: parent.width / 1.05
                    height: billHeader.height * 18 + itemSelection.border.width * 2
                    border {
                        color: "lightgrey"
                        width: billHeader.height / 30
                    }
                    anchors {
                        horizontalCenter: parent.horizontalCenter
                        top: billHeader.bottom
                        topMargin: billHeader.height / 2
                    }
                    ListView {
                        id: itemListView
                        width: itemSelection.width - itemSelection.border.width * 2
                        height: itemSelection.height - itemSelection.border.width * 2
                        anchors.centerIn: parent
                        clip: true
                        model: models.selectModel

                        onCountChanged: {
                            if (count > 0) {
                                currentIndex = count - 1; // Set the currentIndex to the last item
                            }
                        }

                        delegate: Rectangle {
                            id: item
                            height: billHeader.height * 1.8
                            width: parent.width
                            anchors.horizontalCenter: parent.horizontalCenter
                            property int index: model.index

                            Rectangle {
                                id: drinkNameContainer
                                height: parent.height
                                width: parent.width * 8 / 5
                                anchors.left: parent.left
                                anchors.leftMargin: billHeader.height / 5
                                Text {
                                    id: drinkName
                                    text: drink + ((isSizeL) ? " (L)" : " (M)") + "   -   SL: " + quantity
                                    font.pointSize: parent.height / 5
                                    anchors.verticalCenter: parent.verticalCenter
                                    width: parent.width
                                    wrapMode: Text.WrapAnywhere
                                }
                                Text {
                                    id: topping
                                    text: {
                                        var result = ((add.count !== 0) ? "    Extra:      " : "")
                                        for (var key in add) {
                                            result += key + ", ";
                                        }
                                        result = result.slice(0, -2);
                                        return result;
                                    }
                                    anchors.bottom: parent.bottom
                                    font.pointSize: drinkName.font.pointSize / 1.2
                                }
                            }

                            Rectangle {
                                id: costContainer
                                height: parent.height
                                width:  parent.width / 6.5
                                color: "transparent"
                                anchors.right: parent.right
                                Text {
                                    id: cost
                                    text: (!model.isCake)
                                          ? (model.cost + model.extraCost) * model.quantity + ".000"
                                          : (model.cost) * model.quantity + ".000"
                                    font.pointSize: drinkName.font.pointSize
                                    anchors.centerIn: parent
                                }
                            }
                        }
                    }
                }
            }
        }
        Rectangle {
            id: minorScreen
            width: parent.width / 2
            height: parent.height
            anchors.right: parent.right
            Rectangle {
                id: totalContainer
                width: parent.width
                height: parent.height / 4
                anchors.top: parent.top
                color: defaultColor
                Rectangle {
                    width: parent.width / 4
                    height: parent.height / 1.5
                    color: "transparent"
                    anchors {
                        left: parent.left
                        leftMargin: width / 5
                        verticalCenter: parent.verticalCenter
                    }
                    Text {
                        text: qsTr("Tổng số lượng")
                        font.pointSize: parent.height / 8
                        anchors.top: parent.top
                    }
                    Text {
                        text: qsTr("Giảm giá")
                        font.pointSize: parent.height / 8
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    Text {
                        text: qsTr("Tổng tiền")
                        font.pointSize: parent.height / 8
                        anchors.bottom: parent.bottom
                    }
                }
                Rectangle {
                    width: parent.width / 5
                    height: parent.height / 1.5
                    color: "transparent"
                    anchors {
                        right: parent.right
                        rightMargin: width / 5
                        verticalCenter: parent.verticalCenter
                    }
                    Text {
                        id: totalQuantity
                        text: billView.totalQuantityValue
                        font.pointSize: parent.height / 8
                        anchors.top: parent.top
                        anchors.right: parent.right
                    }
                    Text {
                        id: totalDiscount
                        text: "- " + "0.000"
                        font.pointSize: parent.height / 8
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                    }
                    Text {
                        id: totalCost
                        text: billView.totalCostValue + ".000"
                        font.pointSize: parent.height / 8
                        anchors.bottom: parent.bottom
                        anchors.right: parent.right
                    }
                }
            }
            Rectangle {
                id: qrContainer
                width: parent.width
                height: parent.height - totalContainer.height
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                Image {
                   id: qrCodeImg
                   fillMode: Image.PreserveAspectFit
                   width: parent.width
                   height: parent.height
                   anchors.centerIn: parent
                   source: ""
                }
            }
        }
    }
}
