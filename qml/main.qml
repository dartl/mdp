import QtQuick 2.7
import QtQuick.Window 2.2
import QtQuick.Controls 1.4

Window {
    signal usedMenu(int index)
    signal getIndexListJobs(string title)
    signal getIndexListWorkers(int index)
    signal updateGraph()

    visible: true
    id: mainWindow
    objectName: "mainWindow"
    width: 1000
    height: 600
    color: "#cccccc"
    title: "Staff Search"

    property color  fontColor: "#222"
    property color darkFontColor: "#e7e7e7"
    //property for graph
    //property ListModel model_graph: null


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
                    clip: true
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

        NavigationDrawer {
            id: showJobs
            //bug№3
            _rootItem: addArea
            anchors.top: toolBar.bottom
            _openMarginSize: 0
            position: Qt.RightEdge
            /////
            property string titleSearch: "null"

            Rectangle {
                anchors.fill: parent
                color: "#99958c"

                TextField {
                    id: livesearch
                    focus: true
                    width: nav.width
                    height: mainWindow.height * 0.125
                    anchors.top: parent.top
                    anchors.bottom: listJobs.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    placeholderText: "Введите специальность для поиска специалиста"
//                    style: BlackButtonStyle {
//                    }
                    onTextChanged: db_model_jobs.setFilterFixedString(text)
                }

                ListView {
                    id: listJobs
                    clip: true
                    //interactive: false
                    //anchors.fill: parent
                    anchors.top: livesearch.bottom
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right


                    model: db_model_jobs

                    delegate: Button {

                        id: delegateListJobs
                        width: nav.width
                        height: mainWindow.height * 0.125
                        text: title
                        style: BlackButtonStyle {
                        }

                        onClicked: {
                            //console.log(db_model_jobs.get(index));
                            getIndexListJobs(title);

                            //console.log(db_model_jobs.data(ListView.currentIndex,id));
                            //console.log(db_model_jobs.getId(id))
                            //db_model_jobs.getId(index)
                        }
                    }
                }
            }
        }

        NavigationDrawer {
            id: showWorkers
            //bug№3
            _rootItem: addArea
            anchors.top: toolBar.bottom
            _openMarginSize: 0
            position: Qt.RightEdge
            /////

            Rectangle {
                anchors.fill: parent
                color: "#99958c"

                ListView {
                    id: listWorkers
                    clip: true
                    //interactive: false
                    anchors.fill: parent

                    model: db_model_workers

                    delegate: Button {
                        width: nav.width
                        height: mainWindow.height * 0.125

                        text: fio
                        style: BlackButtonStyle {
                        }

                        onClicked: {
                            getIndexListWorkers(index)
                        }
                    }
                }
            }
        }
    }
}
