import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts

Item {
    width: parent.width
    height: parent.height
    property int numOfItemOneRow: 3

    Rectangle {
        id: header
        width: parent.width
        height: parent.height / 10
        color: "white"
        Rectangle {
            width: parent.width
            height: parent.height / 2.5
            color: defaultColor
            anchors.top: parent.top
            clip: true
            Text {
                text: qsTr("✯¸.•´*¨`*•✿ ✿•*`¨*`•.¸✯✯¸.•´*¨`*•✿ ✿•*`¨*`•.¸✯✯¸.•´*¨`*•✿ ✿•*`¨*`•.¸✯✯¸.•´*¨`*•✿ ✿•*`¨*`•.¸✯")
                height: parent.height
                font.pointSize: billView.billHeadFontSize
                opacity: 0.1
            }
        }
    }

    Rectangle {
        width: parent.width
        height: parent.height - header.height
        anchors.top: header.bottom
        clip: true

        Flickable {
            id: flickable
            contentWidth: stackView.width
            contentHeight: stackView.height
            GridView {
                id: gridView
                width: parent.width
                height: parent.height / 1.2
                cellWidth: stackView.width / numOfItemOneRow
                cellHeight: (cellWidth) / numOfItemOneRow
                model: models.cakeModel
                clip: true

                delegate: Rectangle {
                    id: cakeInfoContainer
                    width: gridView.cellWidth / 1.5
                    height: gridView.cellHeight / 1.5
                    radius: cakeImg.radius
                    color: "lightblue"

                    Row {
                        id: row
                        width: height
                        height: parent.height
                        spacing: 2

                        Rectangle {
                            id: cakeImg
                            width: parent.height
                            height: width
                            radius: height / 6
                            color: "grey"
                            Text {
                                text: "Undefined"
                                rotation: -30
                                anchors.centerIn: parent
                                color: "white"
                                horizontalAlignment: Text.AlignHCenter
                                font {
                                    bold: true
                                    pointSize: cakeImg.height / 8
                                }
                            }
                        }

                        Rectangle {
                            id: textInfoContainer
                            width: parent.width - cakeImg.width
                            height: parent.height
                            anchors.left: cakeImg.right
                            anchors.leftMargin: cakeImg.height / 8
                            Column {
                                anchors.fill: parent
                                Rectangle {
                                    id: cakeNameCotainer
                                    width: parent.width
                                    height: parent.height * 3 / 4
                                    Text {
                                        id: cakeName
                                        text: model.cake
                                        font {
                                            pointSize: cakeImg.height / 6
                                            bold: true
                                        }
                                        anchors.top: textInfoContainer.top
                                        wrapMode: Text.WordWrap
                                        width: 12 * cakeName.font.pointSize
                                    }
                                }
                                Rectangle {
                                    id: costNameContainer
                                    width: parent.width
                                    height: parent.height * 1 / 4
                                    anchors {
                                        top: cakeNameCotainer.bottom
                                    }
                                    Text {
                                        id: costName
                                        text: model.cost + ".000"
                                        font.pointSize:  cakeImg.height / 6
                                        font.family: "Arial"
                                        anchors.bottom: cakeImg.bottom
                                    }
                                }
                            }
                        }
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            models.selectModel.append({ "index" : 1, "drink": model.cake, "cost": model.cost,
                                                        "quantity" : 1, "add" : ({}), "extraCost" : 0, "isSizeL" : 0,
                                                        "isCake" : true })
                        }
                    }
                }
            }
            ScrollBar.vertical: ScrollBar {
                policy: ScrollBar.AsNeeded
                height: flickable.height
            }
        }
    }
}
