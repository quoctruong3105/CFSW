import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 2.15

ApplicationWindow {
    id: root
    visible: true
    width: Screen.width
    height: Screen.height
    title: "Coffee Software"
    color: defaultColor
    visibility: Window.FullScreen


    property color defaultColor: "#f5deb3"

    Core {id: core}
    Models {id: models}
    ConfirmDialog {id: dialogs}

    Rectangle {
        id: containMenuView
        width: parent.width / 1.5
        height: parent.height - containBar.height
        anchors {
            top: containBar.bottom
            left: parent.left
            bottom: parent.bottom
            leftMargin: parent.width / 250
            bottomMargin: parent.width / 250
        }

        MenuView {
            id: menuView
            width: parent.width
            height: parent.height
        }
    }

    Rectangle {
        id: containBillView
        width: parent.width - containMenuView.width
        height: containMenuView.height
        anchors {
            left: containMenuView.right
            bottom: containMenuView.bottom
        }

        BillView {
            id: billView
            width: parent.width
            height: parent.height
        }
    }

    Rectangle {
        id: containBar
        width: parent.width / 8
        height: parent.height / 18
        property int index: 0
        OrderBar {
            id: orderBar
            width: parent.width
            height: parent.height
        }
        SearchItem {
            id: search
            width: parent.width * 2
            height: parent.height / 1.5
            anchors {
                verticalCenter: containBar.verticalCenter
                left: orderBar.right
                leftMargin: orderBar.width / 2
            }
        }
    }
}
