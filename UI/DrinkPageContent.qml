import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts

Item {
    width: stackView.width
    height: stackView.height
    property int numOfItemOneRow: 3
    property alias drinkView: gridView


    Rectangle {
        id: header
        width: parent.width
        height: parent.height / 10
        color: "white"
        Text {
            width: parent.width
            text: qsTr("TẤT CẢ MẶT HÀNG")
            font {
                pointSize: parent.height / 4
                bold: true
            }
            anchors {
                verticalCenter: parent.verticalCenter
                left: parent.left
                leftMargin: font.pointSize
            }
        }
    }

    Rectangle {
        id: name
        width: parent.width
        height: parent.height - header.height
        anchors.top: header.bottom
        clip: true

        Flickable {
            id: flickable
            anchors.fill: parent
            contentWidth: stackView.width
            contentHeight: stackView.height
            height: parent
            GridView {
                id: gridView
                width: stackView.width
                height: stackView.height
                cellWidth: stackView.width / numOfItemOneRow
                cellHeight: cellWidth / numOfItemOneRow
                model: models.drinkModel
                property int size: gridView.cellHeight

                delegate: Rectangle {
                    id: drinkInfoContainer
                    width: gridView.cellWidth / 1.5
                    height: gridView.cellHeight / 1.5
                    anchors.bottomMargin: 10
                    anchors.topMargin: 10
                    color: index % 2 === 0 ? "lightblue" : "lightgray"

                    Row {
                        id: row
                        width: height
                        height: parent.height
                        spacing: 2

                        Rectangle {
                            id: drinkImg
                            width: parent.height
                            height: width
                            Image {
                                anchors.fill: parent
                                source: "qrc:/img/soda.png"
                                antialiasing: true
                            }
                        }

                        Rectangle {
                            id: textInfoContainer
                            width: parent.width - drinkImg.width
                            height: parent.height
                            anchors.left: drinkImg.right
                            Column {
                                anchors.fill: parent
                                Rectangle {
                                    id: drinkNameCotainer
                                    width: parent.width
                                    height: parent.height * 3 / 4
                                    Text {
                                        id: drinkName
                                        text: model.drink.toUpperCase()
                                        font {
                                            pointSize: drinkImg.height / 8
                                            bold: true
                                        }
                                        anchors.top: textInfoContainer.top
                                        wrapMode: Text.WordWrap
                                        width: 20 * drinkName.font.pointSize
                                    }
                                }
                                Rectangle {
                                    width: parent.width
                                    height: parent.height * 1 / 4
                                    anchors {
                                        top: drinkNameCotainer.bottom
                                    }
                                    Text {
                                        id: costName
                                        text: model.cost + ".000 VNĐ"
                                        font.pointSize:  drinkImg.height / 8
                                        font.family: "Arial"
                                        anchors.bottom: drinkImg.bottom
                                    }
                                }
                            }
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            console.log("Drink:" + drinkName.text + " - " + costName.text)
                        }
                    }
                }
            }

            ScrollBar.vertical: ScrollBar {
                policy: ScrollBar.AsNeeded
                size: flickable.contentHeight / flickable.height
            }
        }
    }
}
