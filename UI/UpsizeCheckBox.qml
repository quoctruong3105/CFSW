import QtQuick 2.15

Item {
    property bool isSizeL: false

    function updateCheckBox() {
        if(isSizeL) {
            inside.color = "black"
        } else {
            inside.color = "white"
        }
        for(var i = 0; i < models.selectModel.count; ++i) {
            if(models.selectModel.get(i).index === item.index) {
                models.selectModel.setProperty(i, "isSizeL", isSizeL)
                billView.updateTotal()
                break
            }
        }
    }

    Rectangle {
        id: upsize
        width: upSizeContainer.width / 1.3
        height: width
        anchors.horizontalCenter: parent.horizontalCenter
        border.color: "lightgrey"
        radius: height
        antialiasing: true
        Rectangle {
            id: inside
            width: upSizeContainer.width / 2.3
            height: width
            color: "white"
            anchors.centerIn: parent
            radius: height
            antialiasing: true
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                isSizeL = !isSizeL
                updateCheckBox()
            }
        }
    }
    Component.onCompleted: {
        updateCheckBox(isSizeL)
    }
}
