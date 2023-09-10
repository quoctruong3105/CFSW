import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    property alias searchTxt: searchTxt
    Rectangle {
        id: searchField
        width: parent.width
        height: parent.height
        TextField {
            id: searchTxt
            placeholderText: "Nhập tên hàng hóa"
            font.pixelSize: searchField.height / 1.5
            anchors {
                fill: parent
                verticalCenter: containBar.verticalCenter
            }
            onTextEdited: {
                models.drinkModel.clear()
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
