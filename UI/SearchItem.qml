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
                core.dh.queryItem(text, "drinks")
                models.dummyData(models.drinkModel)
            }
        }
        Rectangle {
            id: searchBtn
            width: searchField.height
            height: width
            smooth: true
            antialiasing: true

            Text {
                id: searchText
                text: qsTr("E")
                font {
                    bold: true
                    pointSize: height
                }
                color: "red"
                anchors.centerIn: parent
                scale: 1 // Initial scale is 1
            }

            anchors {
                left: searchField.right
                top: searchField.top
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    searchTxt.text = ""
                    scaleAnimator(searchText)
                }
            }
        }
    }
}
