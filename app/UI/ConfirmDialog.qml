import QtQuick 2.15
import QtQuick.Controls 2.15
//

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
            loginPage.isValidAcc = false
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
                        models.billModel.dummyBillInfo(text)
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
        property bool isConfirmed: false
        property string referDateTime: ""

        Timer {
            id: checkPayTimer
            interval: 1300
            property int timeTry: 0
            repeat: timeTry < 100
            onTriggered: {
                if(timeTry == 1) {
                    core.workerCtrl.startThread()
                }
                core.workerCtrl.startCheck(billView.totalCostValue, requestPayDialog.referDateTime)
                if(requestPayDialog.isConfirmed) {
                    core.workerCtrl.killThread()
                    checkPayTimer.running = false
                }
                else {
                    timeTry++
                }
            }
        }

        Row {
            id: requestPayBtns
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            Button {
                id: payFeatureBtn1
                text: qsTr("Xuất \nhóa đơn")
                width: featureBtnGrp.logOutBtn.width
                height: featureBtnGrp.logOutBtn.height
                font.pointSize: height / 5
                DialogButtonBox.buttonRole: DialogButtonBox.AcceptRole
                visible: {
                    if(choosenSolu.currentIndex == 0) {
                        ((receiveCash.text - billView.totalCostValue) >= 0) ? true : false
                    } else {
                        confirmPaidTxt.text == "Đã xác nhận" ? true: false
                    }
                }
                onClicked: {
                    if(choosenSolu.currentIndex == 0) {
                        requestPayDialog.printBill(receiveCash.text, true)
                    } else {
                        requestPayDialog.printBill(billView.totalCostValue, false)
                    }
                    requestPayDialog.clearPayment()
                    requestPayDialog.close()
                }
            }
            Button {
                id: payFeatureBtn
                text: qsTr("Tạo mã \nQR")
                width: featureBtnGrp.logOutBtn.width
                height: featureBtnGrp.logOutBtn.height
                visible: (choosenSolu.currentIndex == 1) ? true : false
                font.pointSize: height / 5
                onClicked: {
                    var qrCodeGen = core.qrPay.genQRCode(choosenBank.currentIndex,
                                                         billView.totalCostValue + "000")
                    if(qrCodeGen !== "") {
                        core.worker.setTargetRow()
                        clientApp.qrCodeImg.source = qrCodeGen
                        genQRresult.text = "Tạo thanh toán thành công"
                        requestPayDialog.referDateTime = billView.currentTime.text
                        checkPayTimer.running = true
                    } else {
                        genQRresult.text = "Tạo thanh toán thất bại"
                    }
                }
            }
            Button {
                id: payOutBtn
                text: qsTr("Thoát")
                width: featureBtnGrp.logOutBtn.width
                height: featureBtnGrp.logOutBtn.height
                font.pointSize: height / 5
                DialogButtonBox.buttonRole: DialogButtonBox.DestructiveRole
                onClicked: {
                    requestPayDialog.clearPayment()
                    requestPayDialog.close()
                }
            }
        }

        function printBill(receiveCash, solu) {
            var itemModel = models.selectModel
            for (var i = 0; i < itemModel.count; ++i) {
                var itemData = itemModel.get(i);

                core.billGen.collectItemInfo(itemData.index, itemData.drink,
                            (itemData.cost + itemData.extraCost) * itemData.quantity,
                             itemData.quantity, JSON.stringify(itemData.add), itemData.isSizeL, itemData.isCake);
            }
            core.billGen.collectOtherInfo(billView.currentTime.text, core.currentAcc.getCurrentUser(),
                                          billView.totalCostValue, receiveCash, solu,
                                          billView.totalQuantityValue, billView.cardNo.text)

            // Work with DB: save bill, decrease quantiy of material, cake, topping
            core.billGen.printBill()

            // Clear all Data of bill from UI and Core after printing bill
            core.billGen.clearListItem()
            models.selectModel.clear()
            billView.cardNo.text = ""
        }

        function clearPayment() {
            checkPayTimer.running = false
            checkPayTimer.timeTry = 0
            requestPayDialog.isConfirmed = false
            requestPayDialog.referDateTime = ""
            discountCodeTxt.text = ""
            receiveCash.text = ""
            genQRresult.text = ""
            clientApp.qrCodeImg.source = ""
        }

        onRejected: {
            clearPayment()
        }

        onClosed:  {
            models.drinkModel.refreshDrinkState()
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
                color: "transparent"
                Rectangle {
                    id: soluTxtContainer
                    width: parent.width / 2
                    height: parent.height
                    color: "transparent"
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
                    color: "transparent"
                    ComboBox {
                        id: choosenSolu
                        width: parent.width
                        height: parent.height
                        anchors.centerIn: parent
                        model: ListModel {
                            ListElement { text: "Tiền mặt" }
                            ListElement { text: "Chuyển khoản" }
                        }
                        font.pointSize: soluTxt.font.pointSize / 1.2
                        onCurrentValueChanged: {
                            requestPayDialog.clearPayment()
                        }
                    }
                }
            }
            Rectangle {
                id: discountContainer
                width: parent.width
                height: soluContainer.height
                anchors.top: soluContainer.bottom
                color: "transparent"
                Rectangle {
                    id: discountTxtContainer
                    width: parent.width / 2
                    height: parent.height
                    color: "transparent"
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
                    color: "transparent"
                    height: parent.height / 1.5
                    anchors.left: discountTxtContainer.right
                    anchors.verticalCenter: parent.verticalCenter
                    TextField {
                        id: discountCodeTxt
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
                height: parent.height - soluContainer.height - discountContainer.height - payFeatureBtn.height
                anchors.top: discountContainer.bottom
                color: "transparent"
                visible: (choosenSolu.currentValue === "Tiền mặt") ? true : false
                Rectangle {
                    id: receiveContainer
                    width: parent.width
                    height: soluContainer.height
                    anchors.top: soluContainer.bottom
                    color: "transparent"
                    Rectangle {
                        id: receiveTxtContainer
                        width: parent.width / 2
                        height: parent.height
                        color: "transparent"
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
                        color: "transparent"
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
                    color: "transparent"
                    Rectangle {
                        id: changeTxtContainer
                        width: parent.width / 2
                        height: parent.height
                        color: "transparent"
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
                        color: "transparent"
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
                height: parent.height - soluContainer.height - discountContainer.height - payFeatureBtn.height
                anchors.top: discountContainer.bottom
                visible: !payCash.visible
                color: "transparent"
                Row {
                    width: parent.width
                    height: parent.height
                    Rectangle {
                        id: bankChooseContainer
                        width: parent.width / 3.5
                        height: parent.height
                        anchors.verticalCenter: parent.verticalCenter
                        color: "transparent"
                        Column {
                            width: parent.width
                            height: choosenSolu.height * 1.6
                            y: parent.height / 3 * 0.2
                            Text {
                                width: parent.width
                                height: parent.height / 1.5
                                font.pointSize: soluTxt.font.pointSize
                                text: "Chọn Ngân hàng"
                            }
                            ComboBox {
                                id: choosenBank
                                width: choosenSolu.width
                                height: choosenSolu.height
                                model: ["Mặc định", "Dự phòng 1", "Dự phòng 2", "Dự phòng 3"]
                                font.pointSize: soluTxt.font.pointSize / 1.2
                            }
                        }
                        Column {
                            width: parent.width
                            height: choosenSolu.height * 4
                            y: parent.height / 60
                        }
                    }
                    Rectangle {
                        height: parent.height / 1.2
                        width: (parent.width - bankChooseContainer.width) / 1.2
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        Text {
                            id: genQRresult
                            width: parent.width
                            height: parent.height / 3
                            font.pointSize: soluTxt.font.pointSize / 1.2
                            horizontalAlignment: Text.AlignHCenter
                            color: (text == "Tạo thanh toán thành công") ? "green" : "red"
                            anchors.top: parent.top
                        }
                        Text {
                            id: confirmPaidTxt
                            width: parent.width
                            height: parent.height / 3
                            font.pointSize: soluTxt.font.pointSize / 1.2
                            horizontalAlignment: Text.AlignHCenter
                            text: (requestPayDialog.isConfirmed) ? "Đã xác nhận" :
                                  ((genQRresult.text === "Tạo thanh toán thành công") ? "Đang xác nhận" : "")
                            anchors.top: genQRresult.bottom
                            anchors.topMargin: -height / 2
                        }
                        BusyIndicator {
                            id: waitingPayIndicator
                            width: payFeatureBtn.height * 1.2
                            height: width
                            running: (confirmPaidTxt.text == "Đang xác nhận" && !requestPayDialog.isConfirmed)
                            visible: running
                            anchors {
                                centerIn: parent
                                top: confirmPaidTxt.bottom
                            }
                        }
                        Rectangle {
                            width: payFeatureBtn.height
                            height: width
                            visible: (confirmPaidTxt.text == "Đã xác nhận")
                            anchors {
                                centerIn: parent
                                top: confirmPaidTxt.bottom
                            }
                            Text {
                                text: "✅"
                                anchors.centerIn: parent
                                font.pointSize: parent.height / 1.5
                            }
                        }
                    }
                }
            }
        }
    }
}
