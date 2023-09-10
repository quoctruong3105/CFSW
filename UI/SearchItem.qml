import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    Rectangle {
        id: searchField
        width: parent.width
        height: parent.height
        TextField {
            placeholderText: "Nhập tên hàng hóa"
            font.pixelSize: searchField.height / 1.5
            anchors {
                fill: parent
                verticalCenter: containBar.verticalCenter
            }
            onTextEdited: {
                models.drinkModel.clear()
                console.log("1")
                core.dh.exeQuery(text)
                models.dummyData()
            }
        }
        Image {
            id: searchBtn
            width: searchField.height
            height: width
            source: "qrc:/img/search.png"
            fillMode: Image.PreserveAspectFit
            smooth: true
            antialiasing: true
            anchors {
                left: searchField.right
                leftMargin: height / 2
                top: searchField.top
            }
        }
    }
}
