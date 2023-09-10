import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    property alias itemDialog: itemDialog

    Dialog {
        id: itemDialog
        title: "Xác nhận"
        width: menuView.stackView.width / 4
        height: width / 2
        modal: true
        standardButtons: Dialog.Ok | Dialog.Cancel

        Text {
            text: "Bạn muốn chọn mặt hàng này?"
            font.pointSize: itemDialog.height / 10
            anchors.centerIn: parent
        }

        onAccepted: {
            itemDialog.close()
        }

        onRejected: {
            itemDialog.close()
        }
    }
}
