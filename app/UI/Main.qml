import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 2.15

ApplicationWindow {
    id: root
    visible: true
    width: Screen.width / 1.68
    height: Screen.height / 1.68
    title: "Coffee Software"
    color: defaultColor
    x: 0 //Qt.application.screens[1].virtualX + 100
    y: 100 //Qt.application.screens[1].virtualY + 100
    property bool isFullScreen: false
    property color defaultColor: "#E6D5B6"

    Core { id: core }
    Models { id: models }
    ConfirmDialog { id: dialogs }
    Loader {
        ClientApp {
            id: clientApp
        }
    }
    Shortcut {
        context: Qt.ApplicationShortcut
        sequence: "Ctrl+F"
        onActivated: {
            isFullScreen = !isFullScreen;
            if (isFullScreen) {
                root.visibility = Window.FullScreen;
            } else {
                root.visibility = Window.Windowed;
            }
        }
    }

    function scaleAnimator(target) {
        target.scale = 1.3;
        var scaleAnimation = Qt.createQmlObject('import QtQuick 2.15; NumberAnimation {}', target);
        scaleAnimation.target = target;
        scaleAnimation.property = "scale";
        scaleAnimation.to = 1;
        scaleAnimation.duration = 2000;
        scaleAnimation.easing.type = Easing.OutCubic;
        scaleAnimation.start();
    }

    function printScreenInformation(screen) {
        console.log("name: " + screen.name);
        console.log("width: " + screen.width);
        console.log("height: " + screen.height);
        console.log("desktopAvailableWidth: " + screen.desktopAvailableWidth);
        console.log("desktopAvailableHeight: " + screen.desktopAvailableHeight);
        console.log("pixelDensity: " + screen.pixelDensity);
        console.log("virtualX: " + screen.virtualX);
        console.log("virtualY: " + screen.virtualY);
    }

    Component.onCompleted: {
        loginPage.isValidAcc = true
//        core.worker.setup()
    }

    Rectangle {
        id: loginCotainer
        width: parent.width
        height: parent.height
        color: defaultColor
        visible: !content.visible
        LoginPage {
            id: loginPage
            width: parent.width
            height: parent.height
        }
    }

    Rectangle {
        id: content
        width: parent.width
        height: parent.height
        color: defaultColor
        visible: loginPage.isValidAcc && loginPage.isValidLicense

        Rectangle {
            id: containMenuView
            width: parent.width / 1.5
            height: parent.height - containBar.height
            clip: true
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
            clip: false
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
            Text {
                id: decorTxt
                text: "╚════ ❀•°❀°•❀ ════╝"
                font.pointSize: billView.billHeadFontSize
                opacity: 0.1
                anchors {
                    leftMargin: decorTxt.height * 1.8
                    left: search.right
                }
            }
        }
        Rectangle {
            id: featureBar
            height: containBar.height * 1.1
            width: billView.billBackGround.width / 1.05
            anchors.right: parent.right
            color: defaultColor
            FeatureGrpBtn {
                id: featureBtnGrp
                width: parent.width
                height: parent.height
            }
        }
    }
}
