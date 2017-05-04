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

    //program state tracking Modes
    property bool deleteMode: false
    property bool editingMode: false
    property bool visibleGraphMode: false
    property bool searchRightNodesMode: false

    //link to graph
    property alias thisGraph: graph

    //signals for deleteMode
    signal activeDeleteMode
    signal inActiveDeleteMode

    //slots for update Graph
    function onUpdateLeftNodesGraph(title_job) {
        addArea.existNodeMode = data_graph.addLeftNodeGraph(db_model_jobs.getId(db_model_jobs.getIndexByTitle(title_job)))
        graph.update()
    }

    /*  Проверка на повторяемость специльностей.
        Такая ситуация возникает если в БД присутствуют специалисты с одинаковым весом
        и необходимо отобразить несколько специалистов, связанных с одной специальностью.
        Данная функция применяется в проверке свойства visible у NodeLeft в делегаде модели графа.
        На экране не отображаются одинаковые специальности.
    */
    function checkSameNode(idJob) {
        var sameNodes = 0;
        for (var i = 0; i < graph.count(); ++i) {
            if (graph.getElementGraph(i).idJob === idJob) {
                ++sameNodes;
            }
        }
        //console.log("SameNodes " + sameNodes);
        if (sameNodes > 1)
            return false
        else
            return true
    }

    function onUpdateRightNodesGraph() {
        if (editingMode) {
            data_graph.addRightPartGraph()
            graph.update()
            searchRightNodesMode = false
        }
        //else info
    }

    property var deleteNodesList: []

    Graph {
        id: graph
    }

    Flickable {
        id: viewGraph
        anchors.fill: parent
        visible: visibleGraphMode ? true : false
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
                        visible: visibleGraphMode && checkSameNode(modelData.idJob) ? true : false
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
                                        checkDeletedNodeRight.visible = true
                                    }
                                    else {
                                        checkDeletedNodeLeft.visible = false
                                        checkDeletedNodeRight.visible = false

//                                        deleteNodesList.forEach(function(item,i,deleteNodesList){
//                                            if (item.name === "job" && item.value === modelData.idJob) {
//                                                console.log(item)
//                                            }
//                                        })

//                                        inActiveDeleteMode = false
//                                        if (deleteNodesList.length === 0) {
//                                            inActiveDeleteMode()
//                                        }
                                    }
                                }
                            }

                            onPressAndHold: {
                                if (!deleteMode) {
                                    activeDeleteMode()
                                    checkDeletedNodeLeft.visible = true
                                    checkDeletedNodeRight.visible = true

                                    deleteNodesList.push({name: "job", value: modelData.idJob})
                                    deleteNodesList.push({name: "worker", value: modelData.idWorker})
                                }
                            }
                        }
                    }

                    Rectangle {
                        id: nodeRight
                        visible: visibleGraphMode && (modelData.idWorker !== -1) ? true : false
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
                                    addArea.idInfoWorker = modelData.idWorker
                                    addArea.drawer_showWorks.open()
                                }
                            }

                            onPressAndHold: {
                                if (!deleteMode) {
                                    activeDeleteMode()
                                    checkDeletedNodeRight.visible = true
                                    deleteNodesList.push({name: "worker", value: modelData.idWorker})
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    ColumnLayout {
        id: addLayout
        anchors.fill: parent
        spacing: 10

        visible: visibleGraphMode ? false : true

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

