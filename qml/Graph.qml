import QtQuick 2.6
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.0

import ModelGraph 1.0
import Graph 1.0

Pane {
    id: graphView

    //links to main.qml and AdditionalArea.qml
    property var mainWindow: null
    property var addArea: null

    //program state tracking modes
    property bool deleteMode: false
    property bool editingMode: false
    property bool searchRightNodes: false

    //link to graph
    property alias thisGraph: graph

    //signals for deleteMode
    signal activeDeleteMode()
    signal inActiveDeleteMode()

    //slots for update Graph
    function onUpdateLeftNodesGraph(index) {
        //console.log(index)

        data_graph.addLeftNodeGraph(db_model_jobs.getTitle(index))
        graph.update()
    }

    function onUpdateRightNodesGraph() {
        if (editingMode) {
            data_graph.addRightPartGraph()
            graph.update()
            searchRightNodes = true
        }
        //else info
    }

    Graph {
        id: graph
    }

    Flickable {
        id: viewGraph
        anchors.fill: parent
        visible: editingMode ? true : false
        contentWidth: parent.width
        contentHeight: column.height
        flickableDirection: Flickable.VerticalFlick

        Column {
            id: column
            width: parent.width

            Repeater {
                model: graph.data

                delegate: Item {
                    height: nodeLeft.height + 50
                    width: parent.width

                    Rectangle {
                        id: nodeLeft

                        anchors.left: parent.left
                        anchors.leftMargin: 50

                        width: mainWindow.width / 3
                        height: mainWindow.height / 6
                        border {
                            color: Material.color(Material.BlueGrey)
                            width: 3
                        }
                        radius: 20

                        Text {
                            id: textNodeLeft
                            wrapMode: Label.Wrap
                            font.pixelSize: 20
                            anchors.centerIn: parent
                            text: db_model_jobs.getTitle(db_model_jobs.getIndexById(modelData.idJob))
                        }

                        Image {
                            id: checkDeletedNodeLeft
                            visible: false
                            fillMode: Image.Pad
                            source: "qrc:/images/ic-check-deleted-node.png"
                            anchors.right: parent.right
                            horizontalAlignment: Image.AlignHCenter
                            verticalAlignment: Image.AlignVCenter
                        }

                        MouseArea {
                            anchors.fill: parent

                            onClicked: {
                                if (deleteMode) {
                                    if (!checkDeletedNodeLeft.visible) {
                                        checkDeletedNodeLeft.visible = true
                                    }
                                    else {
                                        checkDeletedNodeLeft.visible = false
                                    }
                                }
                            }

                            onPressAndHold: {
                                if (!deleteMode) {
                                    activeDeleteMode()
                                    checkDeletedNodeLeft.visible = true
                                }
                            }
                        }
                    }

                    Rectangle {
                        id: nodeRight
                        visible: searchRightNodes ? true : false

                        anchors.right: parent.right
                        anchors.rightMargin: 50

                        width: mainWindow.width / 3
                        height: mainWindow.height / 6
                        border {
                            color: Material.color(Material.BlueGrey)
                            width: 3
                        }
                        radius: 20

                        Text {
                            id: textNodeRight
                            wrapMode: Label.Wrap
                            font.pixelSize: 20
                            anchors.centerIn: parent
                            text: db_model_workers.getFIO(db_model_workers.getIndexById(modelData.idWorker))
                        }

                        Image {
                            id: checkDeletedNodeRight
                            visible: false
                            fillMode: Image.Pad
                            source: "qrc:/images/ic-check-deleted-node.png"
                            anchors.right: parent.right
                            horizontalAlignment: Image.AlignHCenter
                            verticalAlignment: Image.AlignVCenter
                        }

                        MouseArea {
                            anchors.fill: parent

                            onClicked: {
                                if (deleteMode) {
                                    if (!checkDeletedNodeRight.visible) {
                                        checkDeletedNodeRight.visible = true
                                    }
                                    else {
                                        checkDeletedNodeRight.visible = false
                                    }
                                }
                                else {
                                    addArea.indexInfoWorker = modelData.idWorker
                                    addArea.drawer_showWorks.open()
                                }
                            }

                            onPressAndHold: {
                                if (!deleteMode) {
                                    activeDeleteMode()
                                    checkDeletedNodeRight.visible = true
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    ColumnLayout {
        id: layout
        anchors.fill: parent
        spacing: 10

        visible: editingMode ? false : true

        Label {
            id: labelAdd
            anchors.centerIn: parent
            text: "Нажмите для добавления"
            font.pixelSize: 30
            color: Material.color(Material.Grey)
        }



//        MouseArea {
//            id: mouse
//            anchors.fill: parent
//            onClicked: {
//                editingMode = true
//                //addJobs.open()
////                if (!deleteMode)
////                    graphView.activeDeleteMode();
////                else
////                    graphView.inActiveDeleteMode();
//            }
//        }


    }


//    Popup {
//        id: addJobs
//        x: (mainWindow.width - width) / 2
//        y: mainWindow.height / 6
//        width: Math.min(mainWindow.width, mainWindow.height) / 3 * 1.5
//        height: columnJobs.implicitHeight + topPadding + bottomPadding
//        modal: true
//        focus: true

//        contentItem: ColumnLayout {
//            id: columnJobs
//            Button {
//                id: addButton
//                text: "Добавить специальность"
//                onClicked: {
//                    addJobs.close()
//                }

//                Material.foreground: Material.primary
//                Material.background: "transparent"
//                Material.elevation: 0

//                Layout.preferredWidth: 0
//                Layout.fillWidth: true
//            }

//            Button {
//                id: deleteAllButton
//                text: "Удалить модель"
//                onClicked: {
//                    addJobs.close()
//                    dialogDeleteModel.open()
//                }

//                Material.foreground: Material.Red
//                Material.background: "transparent"
//                Material.elevation: 0

//                Layout.preferredWidth: 0
//                Layout.fillWidth: true
//            }
//        }
//    }


//    Popup {
//        id: dialogDeleteModel
//        x: (mainWindow.width - width) / 2
//        y: mainWindow.height / 6
//        width: Math.min(mainWindow.width, mainWindow.height) / 3 * 2
//        height: columnInfo.implicitHeight + topPadding + bottomPadding
//        modal: true
//        focus: true

//        contentItem: ColumnLayout {
//            id: columnInfo
//            spacing: 20
//            Label {
//                text: "Удалить столько то моделей?"
//                font.pixelSize: 20
//                anchors.top: parent.top
//                anchors.topMargin: 10
//                anchors.horizontalCenter: parent.horizontalCenter

//                color: Material.color(Material.Red)
//            }

//            RowLayout {
//                spacing: 10

//                Button {
//                    id: okButton
//                    text: "Да"
//                    onClicked: {
//                        dialogDeleteModel.close()
//                    }

//                    Material.foreground: Material.Red
//                    Material.background: "transparent"
//                    Material.elevation: 0

//                    Layout.fillWidth: true
//                }

//                Button {
//                    id: cancelButton
//                    text: "Отмена"
//                    onClicked: {
//                        dialogDeleteModel.close()
//                    }

//                    Material.background: "transparent"
//                    Material.elevation: 0

//                    Layout.fillWidth: true
//                }
//            }
//        }
//    }
}

