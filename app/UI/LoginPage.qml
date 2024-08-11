import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: loginPage
    width: parent.width
    height: parent.height
    color: defaultColor
    property bool isValidAcc
    property bool isValidLicense: core.preCondition.getLicenseState()

    Image {
        id: backgroundImg
        width: parent.width
        height: parent.height
        source: "https://seotrends.com.vn/wp-content/uploads/2023/03/hinh-nen-anh-bia-dep.jpg"
    }

    Image {
        id: swImg
        width: parent.width / 20
        height: width * 1.5
        y: parent.height / 5
        source: "qrc:/img/app_icon.ico"
        anchors {
            horizontalCenter: parent.horizontalCenter
        }
        Rectangle {
            id: licenseContainer
            width: usernameInput.width / 10
            height: width
            anchors.top: parent.bottom
            anchors.topMargin: -width / 1.5
            anchors.right: parent.right
            anchors.rightMargin: -width / 3
            color: "transparent"
            Rectangle {
                width: parent.width
                height: width
                radius: width / 2
                color: (isValidLicense) ? "forestgreen" : "red"
                antialiasing: true
                Text {
                    text: (isValidLicense) ? "✓" : "✕"
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    anchors.fill: parent
                    font.pointSize: height / 1.8
                    font.bold: true
                }
            }
        }
    }

    TextField {
        id: usernameInput
        placeholderText: "username"
        font.pointSize: height / 2
        height: parent.height / 22
        width: parent.width / 7
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: swImg.bottom
            topMargin: width / 10
        }
    }

    TextField {
        id: passwordInput
        placeholderText: "password"
        font.pointSize: height / 2
        height: parent.height / 22
        width: parent.width / 7
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: usernameInput.bottom
            topMargin: width / 30
        }
        echoMode: TextField.Password
    }

    Button {
        id: loginBtn
        text: "Login"
        font.pointSize: height / 3
        width: usernameInput.width / 3
        height: width / 2
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: passwordInput.bottom
        anchors.topMargin: width / 10
        onClicked: {
            if(!isValidLicense) {
                return
            }

            var i
            for(i = 0; i < models.accModel.count; ++i) {
                if(usernameInput.text === models.accModel.get(i).username) {
                    if(passwordInput.text === models.accModel.get(i).password) {
                        isValidAcc = 1
                        core.currentAcc.setCurrentUser(usernameInput.text)
                        core.dh.updateAccLog(true, billView.currentTime.text, core.currentAcc.getCurrentUser())
                        usernameInput.text = ""
                        passwordInput.text = ""
                        errorLogin.text = ""
                        break
                    } else {
                        errorLogin.text = "Login failed!"
                    }
                }
            }
            if(i === models.accModel.count) {
                errorLogin.text = "Login failed!"
            }
        }
    }

    Rectangle {
        height: usernameInput.height
        width: usernameInput.width
        color: "transparent"
        Text {
            id: errorLogin
            text: (!isValidLicense) ? "Thiết bị chưa được cấp bản quyền!" : ""
            font.pointSize: passwordInput.font.pointSize
            anchors.centerIn: parent
            color: "red"
        }
        anchors.top: loginBtn.bottom
        anchors.topMargin: width / 20
        anchors.horizontalCenter: parent.horizontalCenter
    }
}
