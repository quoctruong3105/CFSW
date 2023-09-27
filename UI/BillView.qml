import QtQuick 2.15
import QtQuick.Controls

Item {
    property int totalCostValue
    //property alias itemModel: itemSelection.model
    property int totalQuantityValue
    property alias currentTime: dateTime
    property alias billBackGround: billBackGround
    property alias cardNo: cardNo

    function updateTime() {
        var now = new Date();
        var day = ("0" + now.getDate()).slice(-2);
        var month = ("0" + (now.getMonth() + 1)).slice(-2);
        var year = now.getFullYear();
        var hours = ("0" + now.getHours()).slice(-2);
        var minutes = ("0" + now.getMinutes()).slice(-2);

        dateTime.text = day + "/" + month + "/" + year + " " + hours + ":" + minutes
    }


    function updateTotal() {
        totalCostValue = 0
        for(var i = 0; i < models.selectModel.count; ++i) {
            var upCost = 0
            if(models.selectModel.get(i).isSizeL) {
                upCost = 5
            }

            totalCostValue += (models.selectModel.get(i).cost +
                               models.selectModel.get(i).extraCost + upCost) * models.selectModel.get(i).quantity
        }
        totalQuantityValue = 0
        for(var j = 0; j < models.selectModel.count; ++j) {
            totalQuantityValue += models.selectModel.get(j).quantity
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
                height: parent.height / 15
                color: defaultColor

                Text {
                    text: qsTr("HÓA ĐƠN")
                    font.bold: true
                    font.pointSize: parent.height / 3
                    anchors.verticalCenter: parent.verticalCenter
                }

                Rectangle {
                    id: cfIcon
                    height: parent.height / 1.2
                    width: height / 1.5
                    color: "transparent"
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
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
                    anchors {
                        verticalCenter: parent.verticalCenter
                    }
                    font.pointSize: parent.height / 3.75
                }
                Text {
                    id: cardTxt
                    text: "Gắn thẻ  "
                    anchors {
                        left: dateTime.right
                        leftMargin: dateTime.height * 2.5
                        verticalCenter: parent.verticalCenter
                    }
                    font.pointSize: dateTime.font.pointSize
                }
                Rectangle {
                    id: cardContainter
                    width: height
                    height: parent.height / 1.4
                    border.color: "lightgrey"
                    anchors {
                        verticalCenter: parent.verticalCenter
                        left: cardTxt.right
                    }

                    Text {
                        id: cardNo
                        text: qsTr("0")
                        font.pointSize: dateTime.font.pointSize
                        anchors.centerIn: parent
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            cardValueContainer.popup.visible = !cardValueContainer.popup.visible;
                        }
                    }
                }
                ComboBox {
                    id: cardValueContainer
                    font.pointSize: dateTime.font.pointSize
                    width: dateTime.font.pointSize * 12
                    visible: false

                    anchors {
                        top: cardContainter.top
                        verticalCenter: parent.verticalCenter
                        horizontalCenter: cardContainter.horizontalCenter
                    }

                    property color chooseColor: "red"
                    function setCardVal(val) {
                        cardNo.text = val
                    }

                    model: ListModel {
                        ListElement { text1: "1"; text2: "2"; text3: "3" }
                        ListElement { text1: "4"; text2: "5"; text3: "6" }
                        ListElement { text1: "7"; text2: "8"; text3: "9" }
                        ListElement { text1: "10"; text2: "11"; text3: "12" }
                        ListElement { text1: "13"; text2: "14"; text3: "15" }
                        ListElement { text1: "16"; text2: "17"; text3: "18" }
                        ListElement { text1: "19"; text2: "20"}
                    }

                    delegate: Rectangle {
                        height: width / 3
                        width: parent.width

                        Row {
                            anchors.fill: parent
                            Rectangle {
                                border.color: "lightgrey"
                                width: parent.width / 3
                                height: parent.height
                                Text {
                                    anchors.centerIn: parent
                                    text: model.text1
                                }
                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: cardValueContainer.setCardVal(model.text1)
                                }
                            }
                            Rectangle {
                                border.color: "lightgrey"
                                width: parent.width / 3
                                height: parent.height
                                Text {
                                    anchors.centerIn: parent
                                    text: model.text2
                                }
                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: cardValueContainer.setCardVal(model.text2)
                                }
                            }
                            Rectangle {
                                border.color: "lightgrey"
                                width: parent.width / 3
                                height: parent.height
                                Text {
                                    anchors.centerIn: parent
                                    text: model.text3
                                }
                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: cardValueContainer.setCardVal(model.text3)
                                }
                            }
                        }
                    }
                }

            }
            Rectangle {
                id: itemSelection
                width: parent.width / 1.05
                height: billHeader.height * 8 + itemSelection.border.width * 2
                border {
                    color: "lightgrey"
                    width: dateTimeContainer.height / 30
                }
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    top: dateTimeContainer.bottom
                }
                Flickable {
                    width: parent.width
                    height: parent.height
                    anchors.centerIn: parent
                    clip: true
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
                            height: billHeader.height
                            width: parent.width
                            //border.color: "black"
                            anchors.horizontalCenter: parent.horizontalCenter                           
                            property int index: model.index

                            Rectangle {
                                id: removeContainer
                                height: parent.height
                                width: parent.width / 13
                                anchors.left: parent.left
                                anchors.margins: width / 20
                                color: "transparent"
                                Text {
                                    id: removeBtn
                                    text: "✘"
                                    font.bold: true
                                    font.pointSize: parent.height / 3
                                    anchors.centerIn: parent
                                    color: "red"
                                }
                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        for(var i = 0; i < models.selectModel.count; i++) {
                                            if(models.selectModel.get(i).index === item.index) {
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
                                width: parent.width * 8 / 28
                                //color: "transparent"
                                anchors.left: removeContainer.right
                                Text {
                                    id: drinkName
                                    text: model.drink
                                    font.pointSize: parent.height / 5
                                    anchors.verticalCenter: parent.verticalCenter
                                    width: parent.width
                                    wrapMode: Text.WrapAnywhere
                                }
                            }

                            Rectangle {
                                id: upSizeContainer
                                //border.color: "black"
                                height: parent.height / 1.6
                                width: height / 1.2
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: drinkNameContainer.right
                                Column {
                                    anchors.fill: parent
                                    anchors.centerIn: parent
                                    UpsizeCheckBox {
                                        width: upSizeContainer.width / 1.3
                                        height: width
                                        anchors.horizontalCenter: parent.horizontalCenter
                                    }
                                    Text {
                                        text: qsTr("L")
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        font.pointSize: parent.height / 3.5
                                    }
                                }
                            }

                            Rectangle {
                                id: toppingContainer
                                //border.color: "black"
                                width: parent.width / 6
                                height: parent.height
                                anchors.left: upSizeContainer.right
                                anchors.leftMargin: width / 4.2
                                ToppingBox {
                                    id: extraTopping
                                    width: parent.width / 1.2
                                    height: parent.height / 1.2
                                    anchors.centerIn: parent
                                }
                            }

                            Rectangle {
                                id: factorContainer
                                //border.color: "black"
                                height: parent.height
                                width: parent.width / 5
                                color: "transparent"
                                anchors.right: costContainer.left
                                QuantityBox {
                                    id: factor
                                    height: parent.height * 2 / 3
                                    width: parent.width
                                    anchors.centerIn: parent
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
                                    text: (model.cost + model.extraCost + (model.isSizeL ? 5 : 0)) * factor.value + ".000"
                                    font.pointSize: drinkName.font.pointSize
                                    anchors.centerIn: parent
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
                        id: payTxt
                        text: qsTr("YÊU CẦU \nTHANH TOÁN")
                        color: "white"
                        horizontalAlignment: Text.AlignHCenter
                        anchors.centerIn: parent
                        font {
                            bold: true
                            pointSize: payContainer.height / 8
                        }
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            scaleAnimator(payTxt)
                            if(!(models.selectModel.count === 0)) {
                                dialogs.openDialogAtCenter(dialogs.requestPayDialog)
                            }
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
                        id: totalQuantity
                        text: totalQuantityValue
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
            Rectangle {
                id: billFooter
                height: parent.height / 30
                width: itemSelection.width
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                Image {
                    id: swIcon
                    height: parent.height / 1.2
                    width: height / 1.5
                    source: "qrc:/img/app_icon.ico"
                    anchors.right: parent.right
                }
                Text {
                    font.pointSize: parent.height / 3
                    text: qsTr("CFSW v1.0  |  Powered by T&T Studio")
                    anchors.right: swIcon.left
                    anchors.verticalCenter: swIcon.verticalCenter
                    anchors.rightMargin: width / 15
                }
            }
        }
    }
}
