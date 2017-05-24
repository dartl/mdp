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
    signal updateTextDeleteNodeButton

    //slots for update Graph
    function onUpdateLeftNodesGraph(title_job) {
        addArea.existNodeMode = data_graph.addLeftNodeGraph(db_model_jobs.getId(db_model_jobs.getIndexByTitle(title_job)))
        graph.update()
        //console.log("existNodeMode " + addArea.existNodeMode)
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

    function deleteElementNodeList(id,check) {
        var indexRemove = -1;
        for (var i = 0; i < deleteNodesList.length; ++i) {

            if (deleteNodesList[i].id === id &&
                    deleteNodesList[i].check === check) {
                indexRemove = i;
                break;
            }
        }
        if (indexRemove !== -1) {
            deleteNodesList.splice(indexRemove,1);
            return true;
        }
        else
            return false;

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

                                        deleteNodesList.push({id: modelData.idJob, check: true})


                                        if (!checkDeletedNodeRight.visible) {
                                            checkDeletedNodeRight.visible = true
                                            deleteNodesList.push({id: modelData.idWorker, check: false})
                                        }
//                                        updateTextDeleteNodeButton.connect(mainWindow.onUpdateTextDeleteNodeButton)
//                                        updateTextDeleteNodeButton()
//                                        updateTextDeleteNodeButton.disconnect(mainWindow.onUpdateTextDeleteNodeButton)
                                    }
                                    else {
                                        checkDeletedNodeLeft.visible = false
                                        checkDeletedNodeRight.visible = false

                                        deleteElementNodeList(modelData.idJob,true)
                                        deleteElementNodeList(modelData.idWorker,false)

                                        if (deleteNodesList.length === 0) {
                                            inActiveDeleteMode()
                                        }
                                    }
                                }
                            }

                            onPressAndHold: {
                                if (!deleteMode) {
                                    activeDeleteMode()
                                    checkDeletedNodeLeft.visible = true
                                    checkDeletedNodeRight.visible = true

                                    deleteNodesList.push({id: modelData.idJob, check: true})

                                    if (modelData.idWorker !== -1) {
                                        deleteNodesList.push({id: modelData.idWorker, check: false})
                                    }
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

                                        deleteNodesList.push({id: modelData.idWorker, check: false})
                                    }
                                    else {
                                        checkDeletedNodeRight.visible = false

                                        deleteElementNodeList(modelData.idWorker,false)

                                        if (deleteNodesList.length === 0) {
                                            inActiveDeleteMode()
                                        }
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
                                    deleteNodesList.push({id: modelData.idWorker, check: false})
                                }
                            }
                        }
                    }

                    Edge {
                        id: edge_graph
                        visible: nodeRight.visible

                        object_1: nodeLeft
                        object_2: nodeRight
                        colorEdge: Material.color(Material.BlueGrey)
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
            text: qsTr("Click to Add") + qmlTranslator.emptyString
            font.pixelSize: 30
            color: Material.color(Material.Grey)
        }
    }
}

