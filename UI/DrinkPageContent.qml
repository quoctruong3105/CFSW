import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts

Item {
    width: parent.width
    height: parent.height
    property int numOfItemOneRow: 3
    property alias catigory: catigory
    property bool initial: true

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
                text: qsTr("╔⏤⏤⏤╝❀╚⏤⏤⏤╗.•° ✿ °•..•° ✿ °•..•° ✿ °•..•° ✿ °•..•° ✿ °•..•° ✿ °•.")
                height: parent.height
                font.pointSize: billView.billHeadFontSize
                opacity: 0.1
            }
        }

        ComboBox {
            id: catigory
            font.pointSize: parent.height / 6
            font.bold: true
            width: parent.width / 5.5
            anchors {
                top: parent.top
                topMargin: width / 20
                right: parent.right
                rightMargin: width / 22
            }
            model: [ "Tất cả mặt hàng", "Trà", "Cà phê", "Nước ép", "Sinh tố", "Khác" ]
            delegate: ItemDelegate {
                width: catigory.width
                contentItem: Text {
                    text: modelData
                    color: "black"
                    font: catigory.font
                    elide: Text.ElideRight
                    verticalAlignment: Text.AlignVCenter
                }
                highlighted: catigory.highlightedIndex === index
            }
            indicator: Canvas {
                id: canvas
                x: catigory.width - width - catigory.rightPadding
                y: catigory.topPadding + (catigory.availableHeight - height) / 2
                width: parent.width / 10
                height: parent.height / 4
                contextType: "2d"

                Connections {
                    target: catigory
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
                rightPadding: catigory.indicator.width + catigory.spacing

                text: catigory.displayText
                font: catigory.font
                color: "black"
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
            }
            background: Rectangle {
                color: defaultColor
                implicitWidth: parent.width / 20
                implicitHeight: parent.height / 2
                border.width: catigory.visualFocus ? 3 : 2
            }
            onCurrentValueChanged: {
                if(initial == false) {
                    models.drinkModel.clear()
                    if(currentValue === "Tất cả mặt hàng") {
                        core.dh.queryItem("", 0, "drinks")
                    } else if(currentValue === "Trà") {
                        core.dh.queryItem("tra", 1, "drinks")
                    } else if(currentValue === "Cà phê") {
                        core.dh.queryItem("ca phe", 1, "drinks")
                    } else if(currentValue === "Nước ép") {
                        core.dh.queryItem("nuoc ep", 1, "drinks")
                    } else if(currentValue === "Sinh tố") {
                        core.dh.queryItem("sinh to", 1, "drinks")
                    } else if(currentValue === "Khác") {
                        core.dh.queryItem("khac", 1, "drinks")
                    }
                    models.dummyData(models.drinkModel)
                }
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
                model: models.drinkModel
                clip: true
                delegate: Rectangle {
                    id: drinkInfoContainer
                    width: gridView.cellWidth / 1.5
                    height: gridView.cellHeight / 1.5
                    radius: drinkImg.radius
                    color: "lightblue"

                    Row {
                        id: row
                        width: height
                        height: parent.height
                        spacing: 2
                        Rectangle {
                            id: drinkImg
                            width: parent.height
                            height: width
                            radius: height / 6
                            color: (model.state) ? "limegreen" : "red"
                            Text {
                                text: (model.state) ? "Available" : "Sold out"
                                rotation: -30
                                anchors.centerIn: parent
                                color: "white"
                                horizontalAlignment: Text.AlignHCenter
                                font {
                                    bold: true
                                    pointSize: drinkImg.height / 8
                                }
                            }
                        }

                        Rectangle {
                            id: textInfoContainer
                            width: parent.width - drinkImg.width
                            height: parent.height
                            anchors.left: drinkImg.right
                            anchors.leftMargin: drinkImg.height / 8
                            Column {
                                anchors.fill: parent
                                Rectangle {
                                    id: drinkNameCotainer
                                    width: parent.width
                                    height: parent.height * 3 / 4
                                    Text {
                                        id: drinkName
                                        text: model.drink
                                        font {
                                            pointSize: drinkImg.height / 6
                                            bold: true
                                        }
                                        anchors.top: textInfoContainer.top
                                        wrapMode: Text.WordWrap
                                        width: 12 * drinkName.font.pointSize
                                    }
                                }
                                Rectangle {
                                    id: costNameContainer
                                    width: parent.width
                                    height: parent.height * 1 / 4
                                    anchors {
                                        top: drinkNameCotainer.bottom
                                    }
                                    Text {
                                        id: costName
                                        text: model.cost + ".000"
                                        font.pointSize:  drinkImg.height / 6
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
                            models.selectModel.append({ "index" : 1, "drink": model.drink, "cost": model.cost,
                                                        "quantity" : 1, "add" : ({}), "extraCost" : 0, "isSizeL" : 0,
                                                        "isCake" : false })
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
