import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: loginPage
    width: parent.width
    height: parent.height
    color: defaultColor
    property bool isValid
    Image {
        id: swImg
        width: parent.width / 20
        height: width * 1.5
        y: parent.height / 5
        source: "qrc:/img/app_icon.ico"
        anchors {
            horizontalCenter: parent.horizontalCenter
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
            var i
            for(i = 0; i < models.accModel.count; ++i) {
                if(usernameInput.text === models.accModel.get(i).username) {
                    if(passwordInput.text === models.accModel.get(i).password) {
                        isValid = 1
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
        color: defaultColor
        Text {
            id: errorLogin
            text: ""
            font.pointSize: passwordInput.font.pointSize
            anchors.centerIn: parent
            color: "red"
        }
        anchors.top: loginBtn.bottom
        anchors.topMargin: width / 20
        anchors.horizontalCenter: parent.horizontalCenter
    }
}
