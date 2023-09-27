import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    property alias requestPayDialog: requestPayDialog
    property int smallWidth: menuView.stackView.width / 3
    property int smallheight: smallWidth / 2
    property int mediumWidth: menuView.stackView.width / 1.2
    property int mediumHeight: menuView.stackView.height / 1.5
    property int mediumWidth1: menuView.stackView.width / 2
    property int mediumHeight1: menuView.stackView.height / 2


    function openDialogAtCenter(dialogName) {
        dialogName.x = (menuView.stackView.width - dialogName.width) / 2
        dialogName.y = (menuView.stackView.height - dialogName.height) / 2
        dialogName.open()
    }

    function callDialog(btnId) {
        btnId.color = featureBtnGrp.chooseColor
        if(btnId === featureBtnGrp.logOutBtn) {
            openDialogAtCenter(logOutDialog)
        } else if(btnId === featureBtnGrp.refreshBillBtn) {
            openDialogAtCenter(refreshBillDialog)
        } else if(btnId === featureBtnGrp.findBillBtn) {
            openDialogAtCenter(findBillDialog)
        }
    }

    Dialog {
        id: logOutDialog
        title: "Xác nhận"
        width: smallWidth
        height: smallheight
        modal: true
        standardButtons: Dialog.Ok | Dialog.Cancel

        Text {
            text: "Bạn muốn đăng xuất?"
            font.pointSize: logOutDialog.height / 10
            anchors.centerIn: parent
        }
        onAccepted: {
            core.dh.updateAccLog(false, billView.currentTime.text, core.currentAcc.getCurrentUser())
            loginPage.isValid = false
            featureBtnGrp.resetAllToNormal()
        }
        onRejected: {
            featureBtnGrp.resetAllToNormal()
        }
    }

    Dialog {
        id: refreshBillDialog
        title: "Xác nhận"
        width: smallWidth
        height: smallheight
        modal: true
        standardButtons: Dialog.Ok | Dialog.Cancel

        Text {
            text: "Bạn muốn làm mới hóa đơn?"
            font.pointSize: refreshBillDialog.height / 10
            anchors.centerIn: parent
        }
        onAccepted: {
            core.billGen.clearListItem()
            models.selectModel.clear()
            billView.cardNo.text = "0"
            featureBtnGrp.resetAllToNormal()
        }
        onRejected: {
            featureBtnGrp.resetAllToNormal()
        }
    }

    Dialog {
        id: findBillDialog
        title: "Truy suất hóa đơn"
        width: mediumWidth
        height: mediumHeight
        modal: true
        standardButtons: Dialog.Close
        property int textSize: height / 60
        Rectangle {
            id: searchBillBar
            width: parent.width
            height: parent.height / 15
            TextField {
                width: parent.width
                height: parent.height
                placeholderText: "Nhập mã hóa đơn"
                font.pointSize: height / 2
                onTextChanged: {
                    if(text.length == 8) {
                        models.dummyBillInfo(text)
                    }
                }
            }
        }
        Rectangle {
            width: parent.width
            height: parent.height - searchBillBar.height
            anchors.top: searchBillBar.bottom
            anchors.topMargin: searchBillBar.height / 2
            clip: true
            Rectangle {
                id: header
                width: parent.width
                height: parent.height / 8
                anchors.top: parent.top
                Rectangle {
                    id: receiptHeader
                    width: parent.width * 1.2 / 15
                    height: parent.height
                    border.color: "black"
                    anchors.left: parent.left
                    clip: true
                    Text {
                        text: "Mã đ.hàng"
                        font.pointSize: findBillDialog.textSize
                        anchors.centerIn: parent
                    }
                }
                Rectangle {
                    id: dateTimeHeader
                    width: parent.width * 2 / 15
                    height: parent.height
                    border.color: "black"
                    anchors.left: receiptHeader.right
                    clip: true
                    Text {
                        anchors.centerIn: parent
                        font.pointSize: findBillDialog.textSize
                        text: "Ngày giờ"
                    }
                }
                Rectangle {
                    id: cashierHeader
                    width: parent.width * 1.2 / 15
                    height: parent.height
                    border.color: "black"
                    anchors.left: dateTimeHeader.right
                    clip: true
                    Text {
                        anchors.centerIn: parent
                        font.pointSize: findBillDialog.textSize
                        text: "Thu ngân"
                    }
                }
                Rectangle {
                    id: itemsHeader
                    width: parent.width * 6.6 / 15
                    height: parent.height
                    border.color: "black"
                    anchors.left: cashierHeader.right
                    clip: true
                    Text {
                        anchors.centerIn: parent
                        font.pointSize: findBillDialog.textSize
                        text: "Hàng hóa"
                    }
                }
                Rectangle {
                    id: grandTotalHeader
                    width: parent.width / 15
                    height: parent.height
                    border.color: "black"
                    anchors.left: itemsHeader.right
                    clip: true
                    Text {
                        anchors.centerIn: parent
                        font.pointSize: findBillDialog.textSize
                        text: "Tổng"
                    }
                }
                Rectangle {
                    id: cashReceiveHeader
                    width: parent.width / 15
                    height: parent.height
                    border.color: "black"
                    anchors.left: grandTotalHeader.right
                    clip: true
                    Text {
                        anchors.centerIn: parent
                        font.pointSize: findBillDialog.textSize
                        text: "Nhận"
                    }
                }
                Rectangle {
                    id: cashChangeHeader
                    width: parent.width / 15
                    height: parent.height
                    border.color: "black"
                    anchors.left: cashReceiveHeader.right
                    clip: true
                    Text {
                        anchors.centerIn: parent
                        font.pointSize: findBillDialog.textSize
                        text: "Trả"
                    }
                }
                Rectangle {
                    id: remittanceHeader
                    width: parent.width / 15
                    height: parent.height
                    border.color: "black"
                    anchors.left: cashChangeHeader.right
                    clip: true
                    Text {
                        anchors.centerIn: parent
                        font.pointSize: findBillDialog.textSize
                        text: "P.thức"
                    }
                }
            }
            ListView {
                id: billInfoView
                width: parent.width
                height: parent.height - header.height
                model: models.billModel
                anchors.top: header.bottom
                delegate: Item {
                    width: billInfoView.width
                    height: billInfoView.height
                    Rectangle {
                        id: receiptIdCol
                        width: parent.width * 1.2 / 15
                        height: parent.height
                        border.color: "black"
                        anchors.left: parent.left
                        clip: true
                        Text {
                            anchors.centerIn: parent
                            font.pointSize: findBillDialog.textSize
                            text: model.recieptId
                        }
                    }
                    Rectangle {
                        id: dateTimeCol
                        width: parent.width * 2 / 15
                        height: parent.height
                        border.color: "black"
                        anchors.left: receiptIdCol.right
                        clip: true
                        Text {
                            anchors.centerIn: parent
                            font.pointSize: findBillDialog.textSize
                            text: model.dateTime
                        }
                    }
                    Rectangle {
                        id: cashierCol
                        width: parent.width * 1.2 / 15
                        height: parent.height
                        border.color: "black"
                        anchors.left: dateTimeCol.right
                        clip: true
                        Text {
                            anchors.centerIn: parent
                            font.pointSize: findBillDialog.textSize
                            text: model.cashier
                        }
                    }
                    Rectangle {
                        id: itemsCol
                        width: parent.width * 6.6 / 15
                        height: parent.height
                        border.color: "black"
                        anchors.left: cashierCol.right
                        clip: true
                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            x: parent.width / 30
                            text: model.items
                            font.pointSize: findBillDialog.textSize
                            wrapMode: Text.WordWrap
                        }
                    }
                    Rectangle {
                        id: grandTotalCol
                        width: parent.width / 15
                        height: parent.height
                        border.color: "black"
                        anchors.left: itemsCol.right
                        clip: true
                        Text {
                            anchors.centerIn: parent
                            font.pointSize: findBillDialog.textSize
                            text: model.grandTotal
                        }
                    }
                    Rectangle {
                        id: cashReceiveCol
                        width: parent.width / 15
                        height: parent.height
                        border.color: "black"
                        anchors.left: grandTotalCol.right
                        clip: true
                        Text {
                            anchors.centerIn: parent
                            font.pointSize: findBillDialog.textSize
                            text: model.cashReceive
                        }
                    }
                    Rectangle {
                        id: cashChangeCol
                        width: parent.width / 15
                        height: parent.height
                        border.color: "black"
                        anchors.left: cashReceiveCol.right
                        clip: true
                        Text {
                            anchors.centerIn: parent
                            font.pointSize: findBillDialog.textSize
                            text: model.cashChange
                        }
                    }
                    Rectangle {
                        id: remittanceId
                        width: parent.width / 15
                        height: parent.height
                        border.color: "black"
                        anchors.left: cashChangeCol.right
                        clip: true
                        Text {
                            anchors.centerIn: parent
                            font.pointSize: findBillDialog.textSize
                            text: model.isCash
                        }
                    }
                }
            }
        }

        onClosed: {
            featureBtnGrp.resetAllToNormal()
        }
    }

    Dialog {
        id: requestPayDialog
        title: "Yêu cầu thanh toán"
        width: mediumWidth1
        height: mediumHeight1
        modal: true
        standardButtons: Dialog.Ok | Dialog.Cancel

        function printBill() {
            var itemModel = models.selectModel
            for (var i = 0; i < itemModel.count; ++i) {
                var itemData = itemModel.get(i); // Assuming itemModel.get(i) returns an object with the required properties

                // Call the C++ function with the correct argument order and data types
                core.billGen.collectItemInfo(itemData.index, itemData.drink,
                            (itemData.cost + itemData.extraCost + ((itemData.isSizeL) ? 5 : 0)) *  itemData.quantity,
                            itemData.quantity, JSON.stringify(itemData.add), itemData.isSizeL);
            }
            core.billGen.collectOtherInfo(currentTime.text, core.currentAcc.getCurrentUser(), totalCostValue, 100)

            // Clear all Data of bill from UI and Core
            core.billGen.printBill()
            core.billGen.clearListItem()
            models.selectModel.clear()
            billView.cardNo.text = "0"
        }

        Rectangle {
            width: parent.width / 1.05
            height: parent.height
            anchors.centerIn: parent
            color: "transparent"
            Rectangle {
                id: soluContainer
                width: parent.width
                height: parent.height / 7
                anchors.top: parent.top
                Rectangle {
                    id: soluTxtContainer
                    width: parent.width / 2
                    height: parent.height
                    Text {
                        id: soluTxt
                        width: parent.width / 1.2
                        font.pointSize: parent.height / 3.5
                        anchors.verticalCenter: parent.verticalCenter
                        text: "Phương thức thanh toán"
                    }
                }
                Rectangle {
                    width: parent.width / 3.5
                    height: parent.height / 1.5
                    anchors.left: soluTxtContainer.right
                    anchors.verticalCenter: parent.verticalCenter
                    ComboBox {
                        id: choosenSolu
                        width: parent.width
                        height: parent.height
                        anchors.centerIn: parent
                        model: ListModel {
                            ListElement { text: "Tiền mặt" } // Payment method options
                            ListElement { text: "Chuyển khoản" }
                        }
                        font.pointSize: soluTxt.font.pointSize
                    }
                }
            }
            Rectangle {
                id: discountContainer
                width: parent.width
                height: soluContainer.height
                anchors.top: soluContainer.bottom
                Rectangle {
                    id: discountTxtContainer
                    width: parent.width / 2
                    height: parent.height
                    Text {
                        id: discountTxt
                        width: parent.width / 1.2
                        font.pointSize: parent.height / 3.5
                        anchors.verticalCenter: parent.verticalCenter
                        text: "Nhập mã giảm giá"
                    }
                }
                Rectangle {
                    width: parent.width / 3.5
                    height: parent.height / 1.5
                    anchors.left: discountTxtContainer.right
                    anchors.verticalCenter: parent.verticalCenter
                    TextField {
                        width: parent.width
                        height: parent.height
                        anchors.centerIn: parent
                        verticalAlignment: TextInput.AlignVCenter
                        font.pointSize: soluTxt.font.pointSize
                        onTextChanged: {
                            if(text.length === 5) {
                                checkValidTxt.text = "✔"
                                checkValidTxt.visible = true
                            } else if(text.length === 0) {
                                checkValidTxt.text = ""
                                checkValidTxt.visible = false
                            } else {
                                checkValidTxt.text = "✘"
                                checkValidTxt.visible = true
                            }
                        }
                    }
                }
                Text {
                    id: checkValidTxt
                    visible: false
                    color: (text === "✔" && visible) ? "green" : "red"
                    anchors.right: parent.right
                    anchors.rightMargin: parent.height / 5
                    anchors.verticalCenter: parent.verticalCenter
                    font.pointSize: soluTxt.font.pointSize * 1.5
                }
            }

            Rectangle {
                id: payCash
                width: parent.width
                height: parent.height - soluContainer.height - discountContainer.height
                anchors.top: discountContainer.bottom
                visible: (choosenSolu.currentValue === "Tiền mặt") ? true : false
                Rectangle {
                    id: receiveContainer
                    width: parent.width
                    height: soluContainer.height
                    anchors.top: soluContainer.bottom
                    Rectangle {
                        id: receiveTxtContainer
                        width: parent.width / 2
                        height: parent.height
                        Text {
                            width: parent.width / 1.2
                            font.pointSize: parent.height / 3.5
                            anchors.verticalCenter: parent.verticalCenter
                            text: "Số tiền nhận"
                        }
                    }
                    Rectangle {
                        width: parent.width / 12
                        height: parent.height / 1.5
                        anchors.left: receiveTxtContainer.right
                        anchors.verticalCenter: parent.verticalCenter
                        TextField {
                            id: receiveCash
                            width: parent.width
                            height: parent.height
                            verticalAlignment: TextInput.AlignVCenter
                            font.pointSize: soluTxt.font.pointSize
                        }
                        Text {
                            width: parent.width / 1.2
                            font.pointSize: soluTxt.font.pointSize
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: receiveCash.right
                            text: " .000"
                        }
                    }
                }

                Rectangle {
                    id: changeContainer
                    width: parent.width
                    height: soluContainer.height
                    anchors.top: receiveContainer.bottom
                    Rectangle {
                        id: changeTxtContainer
                        width: parent.width / 2
                        height: parent.height
                        Text {
                            width: parent.width / 1.2
                            font.pointSize: parent.height / 3.5
                            anchors.verticalCenter: parent.verticalCenter
                            text: "Số tiền trả"
                        }
                    }
                    Rectangle {
                        width: parent.width / 12
                        height: parent.height / 1.5
                        anchors.left: changeTxtContainer.right
                        anchors.verticalCenter: parent.verticalCenter
                        Text {
                            id: changeCash
                            text: receiveCash.text - billView.totalCostValue + ".000"
                            color: ((receiveCash.text - billView.totalCostValue) >= 0)
                                   ? "green" : "red"
                            width: parent.width
                            height: parent.height
                            anchors.verticalCenter: parent.verticalCenter
                            font {
                                bold: true
                                pointSize: soluTxt.font.pointSize
                            }
                        }
                    }
                }
            }

            Rectangle {
                id: payQR
                width: parent.width
                height: parent.height - soluContainer.height - discountContainer.height
                anchors.top: discountContainer.bottom
                visible: !payCash.visible
                Row {
                    width: parent.width
                    height: parent.height
                    Rectangle {
                        id: bankChooseContainer
                        width: parent.width / 3.5
                        height: soluTxtContainer.height * 1.8
                        anchors.verticalCenter: parent.verticalCenter
                        Column {
                            anchors.fill: parent
                            Text {
                                width: parent.width
                                height: parent.height / 2
                                font.pointSize: soluTxt.font.pointSize
                                text: "Chọn Ngân hàng"
                            }
                            ComboBox {
                                id: choosenBank
                                width: choosenSolu.width
                                height: choosenSolu.height
                                anchors.centerIn: parent
                                //model:
                                font.pointSize: soluTxt.font.pointSize
                            }
                        }
                    }
                    Rectangle {
                        height: parent.height
                        width: parent.width - bankChooseContainer.width
                        Image {
                            id: qrCodeImg
                            fillMode: Image.PreserveAspectFit
                            anchors.fill: parent
                            source: ""
                            onSourceChanged: {
                                if(qrCodeImg.source !== "") {
                                    core.qrPay.startConfirm()
                                }
                            }
                        }

                        // Test
                        MouseArea {
                            anchors.fill: parent;
                            onClicked: {
                                qrCodeImg.source = core.qrPay.genQRCode(0, billView.totalCostValue + "000")
                            }
                        }
                    }
                }
            }
        }
    }
}
