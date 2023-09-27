import QtQuick 2.15
import Qt.DataHandle.Module 1.0
import Qt.Account.Module 1.0
import Qt.BillGenerator.Module 1.0
import Qt.QRPayment.Module 1.0

Item {
    property alias dh: dh
    property alias currentAcc: currentAcc
    property alias billGen: billGen
    property alias qrPay: qrPay

    DataHandler {
        id: dh
    }
    Account {
        id: currentAcc
    }
    BillGenerator {
        id: billGen
    }
    QRPayment {
        id: qrPay
    }
}
