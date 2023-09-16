import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: loginPage
    width: parent.width
    height: parent.height
    color: defaultColor
    property bool isValid

    Column {
        width: parent.width / 20
        spacing: width / 10
        anchors.horizontalCenter: parent.horizontalCenter
        y: parent.height / 3

        TextField {
            id: usernameInput
            placeholderText: "username"
            font.pointSize: height / 2
            height: parent.width / 2
            width: parent.width * 3
        }

        TextField {
            id: passwordInput
            placeholderText: "password"
            font.pointSize: height / 2
            height: parent.width / 2
            width: parent.width * 3
            echoMode: TextField.Password
        }

        Button {
            text: "Login"
            font.pointSize: usernameInput.height / 2.5
            width: usernameInput.width / 3
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: {
                var i = 0
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
                if(i == models.accModel.count) {
                    errorLogin.text = "Login failed!"
                }
            }
        }

        Text {
            id: errorLogin
            height: parent.width / 2
            width: parent.width * 3
            text: ""
            font.pointSize: passwordInput.font.pointSize
            color: "red"
        }
    }
}
