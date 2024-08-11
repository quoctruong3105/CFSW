import QtQuick 2.15
import Tt.DataHandle.Module 1.0
import Tt.Account.Module 1.0
import Tt.BillGenerator.Module 1.0
import Tt.QRPayment.Module 1.0
import Tt.Worker.Module 1.0
import Tt.WorkerController.Module 1.0
import Tt.Inventory.Module 1.0
import Tt.Discount.Module 1.0
import Tt.PreCondition.Module 1.0

Item {
    property alias dh: dh
    property alias currentAcc: currentAcc
    property alias billGen: billGen
    property alias qrPay: qrPay
    property alias workerCtrl: workerCtrl
    property alias worker: worker
    property alias inventory: inventory
    property alias discount: discount
    property alias preCondition: preCondition

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
    Inventory {
        id: inventory
    }
    Worker {
        id: worker
    }
    Discount {
        id: discount
    }
    PreCondition {
        id: preCondition
    }
    WorkerController {
        id: workerCtrl
        onGetConfirmed: {
            dialogs.requestPayDialog.isConfirmed = isConfirmed
        }
    }
}
