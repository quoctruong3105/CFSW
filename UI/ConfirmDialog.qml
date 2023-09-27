import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt.labs.qmlmodels 1.0

Item {
    property alias logOutDialog: logOutDialog
    property alias refreshBillDialog: refreshBillDialog
    property alias findBillDialog: findBillDialog
    property int smallWidth: menuView.stackView.width / 3
    property int smallheight: smallWidth / 2
    property int mediumWidth: menuView.stackView.width / 1.2
    property int mediumHeight: menuView.stackView.height / 2

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
    }

    Dialog {
        id: findBillDialog
        title: "Truy suất hóa đơn"
        width: mediumWidth
        height: mediumHeight
        modal: true
        standardButtons: Dialog.Close
        Rectangle {
            id: searchBillBar
            width: parent.width
            height: parent.height / 10
            TextField {
                width: parent.width
                height: parent.height
                placeholderText: "Nhập mã hóa đơn"
                font.pointSize: height / 2
                onTextChanged: {
                    core.dh.queryBill(text)
                }
            }
        }
        Rectangle {
            id: rectangle
            color: defaultColor
            width: parent.width
            height: parent.height - searchBillBar.height
            anchors.top: searchBillBar.bottom
            anchors.topMargin: searchBillBar.height / 2
        }
    }
}
