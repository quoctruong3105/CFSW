import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts
import Qt.labs.settings

Item {
    width: parent.width
    height: parent.height
    property int numOfItemOneRow: 3
    //property alias cakeView: gridView
//    Rectangle {

//        width: parent.width
//        height: parent.height
//        color: "yellow"
//    }

    Rectangle {
        id: header
        width: parent.width
        height: parent.height / 10
        color: "white"
        Rectangle {
            width: parent.width
            height: parent.height / 3.2
            color: defaultColor
            anchors.top: parent.top
        }

        ComboBox {
            id: control
            font.pointSize: parent.height / 6
            font.bold: true
            width: parent.width / 5.5
            anchors {
                top: parent.top
                topMargin: width / 20
                right: parent.right
                rightMargin: width / 22
            }
            model: ["Tất cả mặt hàng", "Cà phê", "Sinh tố", "Nước ép", "Khác"]
            delegate: ItemDelegate {
                width: control.width
                contentItem: Text {
                    text: modelData
                    color: "black"
                    font: control.font
                    elide: Text.ElideRight
                    verticalAlignment: Text.AlignVCenter
                }
                highlighted: control.highlightedIndex === index
            }
            indicator: Canvas {
                id: canvas
                x: control.width - width - control.rightPadding
                y: control.topPadding + (control.availableHeight - height) / 2
                width: parent.width / 10
                height: parent.height / 4
                contextType: "2d"

                Connections {
                    target: control
                    function onPressedChanged() { canvas.requestPaint(); }
                }

                onPaint: {
                    context.reset();
                    context.moveTo(0, 0);
                    context.lineTo(width, 0);
                    context.lineTo(width / 2, height);
                    context.closePath();
                    context.fillStyle = "black"
                    context.fill();
                }
            }
            contentItem: Text {
                leftPadding: 0
                rightPadding: control.indicator.width + control.spacing

                text: control.displayText
                font: control.font
                color: "black"
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
            }
            background: Rectangle {
                color: defaultColor
                implicitWidth: parent.width / 20
                implicitHeight: parent.height / 2
                border.width: control.visualFocus ? 3 : 2
            }
            onCurrentValueChanged: {
                search.searchTxt.text = ""
                if(currentValue === "Tất cả mặt hàng") {
                    models.cakeModel.clear()
                    core.dh.exeQuery("")
                    models.dummyData()
                } else if(currentValue === "Sinh tố") {
                    models.cakeModel.clear()
                    core.dh.exeQuery("sinh to")
                    models.dummyData()
                } else if(currentValue === "Nước ép") {
                    models.cakeModel.clear()
                    core.dh.exeQuery("nuoc ep")
                    models.dummyData()
                } else if(currentValue === "Cà phê") {
                    models.cakeModel.clear()
                    core.dh.exeQuery("ca phe")
                    models.dummyData()
                }
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
                cellHeight: (cellWidth / 1.2) / numOfItemOneRow
                model: models.cakeModel
                property int size: gridView.cellHeight

                delegate: Rectangle {
                    id: cakeInfoContainer
                    width: gridView.cellWidth / 1.5
                    height: gridView.cellHeight / 1.5
                    anchors.bottomMargin: 10
                    anchors.topMargin: 10
                    //color: index % 2 === 0 ? "lightblue" : "lightgray"

                    Row {
                        id: row
                        width: height
                        height: parent.height
                        spacing: 2

                        Rectangle {
                            id: cakeImg
                            width: parent.height
                            height: width
                            radius: height / 5
                            color: "lightgrey"
                            Image {
                                anchors.fill: parent
                                source: "qrc:/img/soda.png"
                                antialiasing: true
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
                                        text: model.cake.toUpperCase()
                                        font {
                                            pointSize: cakeImg.height / 5.5
                                            bold: true
                                        }
                                        anchors.top: textInfoContainer.top
                                        wrapMode: Text.WordWrap
                                        width: 20 * cakeName.font.pointSize
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
                            var itemExists = false
                            for (var i = 0; i < models.selectModel.count; i++) {
                                if (models.selectModel.get(i).cake === cakeName.text) {
                                    itemExists = true;
                                    break;
                                }
                            }
                            if (!itemExists) {
                                models.selectModel.append({ "cake": cakeName.text, "cost": costName.text, "qualtity" : 1 });
                            }
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
