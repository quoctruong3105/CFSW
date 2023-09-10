import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    property alias stackView: stackView
    property alias drinkPageContent: drinkPageContent
    property alias cakePageContent: cakePageContent
    property alias cakePage: cakePage

    StackView {
        id: stackView
        objectName: stackView
        anchors.fill: parent
        width: parent.width
        height: parent.height
        anchors.left: parent.left
        initialItem: drinkPage
        clip: true

        Page {
            id: drinkPage
            title: "Drink"
            DrinkPageContent {
                id: drinkPageContent
            }
        }

        Page {
            id: cakePage
            title: "Cake"
            CakePageCotent {
                id: cakePageContent
            }
        }
    }
}
