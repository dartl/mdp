import QtQuick 2.7
import QtQuick.Window 2.2
import QtQuick.Controls 1.4

Window {
    signal usedMenu(int index)

    visible: true
    id: mainWindow
    objectName: "mainWindow"
    width: 1000
    height: 600
    color: "#cccccc"
    title: "Staff Search"

    property color  fontColor: "#222"
    property color darkFontColor: "#e7e7e7"

    // Пересчёт независимых от плотности пикселей в физические пиксели устройства
    readonly property int dpi: Screen.pixelDensity * 25.4
    function dp(x){ return (dpi < 120) ? x : x*(dpi/160); }

    FontLoader {
        id: openSans
        source: "qrc:/fonts/OpenSans-Regular.ttf"
     }

    Text {
        id: textSingleton
    }

    //костыль-обертка для всех элементов, для грамотного расположения
    Rectangle {
        id: workArea
        anchors.fill: parent

        ControlViewToolBar {
            id: toolBar
        }

        AdditionArea {
            id: addArea
            anchors.top: toolBar.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
        }

        NavigationDrawer {
            id: nav
            //bug№3
            _rootItem: addArea
            anchors.top: toolBar.bottom
            _openMarginSize: 0
            //////
            Rectangle {
                anchors.fill: parent

                color: "#99958c"

                ListView {
                    interactive: false
                    anchors.fill: parent
                    //Модель данных для списка меню
                    model: ListModel {
                        ListElement {title: "Создать"; icon: "qrc:/images/icon-create-menu.png"}
                        ListElement {title: "Открыть"; icon: "qrc:/images/icon-open-menu.png"}
                        ListElement {title: "Сохранить"; icon: "qrc:/images/icon-save-menu.png"}
                        ListElement {title: "Сохранить как"; icon: "qrc:/images/icon-save-menu.png"}
                        ListElement {title: "Выход"; icon: "qrc:/images/icon-exit-menu.png"}
                    }

                    delegate: Button {
                        width: nav.width
                        height: mainWindow.height * 0.125
                        text: title
                        iconSource: icon
                        style: BlackButtonStyle {
                        }

                        onClicked: {
                            usedMenu(index)
                        }
                    }
                }
            }
        }
    }
}
