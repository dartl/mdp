import QtQuick 2.6
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.0

Pane {
    id: additionArea

    //link to main.qml
    property var pointer_mainWindow: null

    //links to Components
    property alias drawer_showJobs: showJobs
    property alias drawer_showWorks: showWorks
    property alias graph: graph

    property int idInfoWorker: -1

    //program state tracking Mode
    property bool existNodeMode: false

    //signals for update Graph
    signal updateLeftNodesGraph(string title_job)

    function getSpecialties(id) {
        var text_specialties = "";
        for (var i = 0; i < db_model_relations.elementsCount(); ++i) {
            if (db_model_relations.getIdSpecialist(i) === id) {
                text_specialties +=
                        db_model_jobs.getTitle(db_model_jobs.getIndexById(db_model_relations.getIdSpecialty(i)));
                text_specialties += "\n";
            }
        }
        return text_specialties;
    }

    Graph {
        id: graph
        anchors.fill: parent
        mainWindow: pointer_mainWindow
        addArea: additionArea
    }

    Drawer {
        id: showJobs
        edge: Qt.RightEdge
        width: Math.min(pointer_mainWindow.width, pointer_mainWindow.height) / 3 * 2
        height: pointer_mainWindow.height
        dragMargin: 0

        Pane {
            id: paneSearch
            focus: true

            TextField {
                id: liveSearch
                focus: true
                width: showJobs.width - Math.min(imgSearch.width,imgSearch.height) - 20
                placeholderText: "Введите специальность"
                onTextChanged: db_model_jobs_filter.setFilterFixedString(text)
            }

            Image {
                id: imgSearch
                fillMode: Image.Pad
                anchors.left: liveSearch.right
                anchors.leftMargin: 4
                anchors.top: parent.top
                anchors.topMargin: 8
                source: "qrc:/images/icon-search-add.png"
                horizontalAlignment: Image.AlignHCenter
                verticalAlignment: Image.AlignVCenter
            }
        }

        ListView {
            id: listJobs
            clip: true
            currentIndex: -1
            anchors.top: paneSearch.bottom
            anchors.topMargin: paneSearch.height + 4
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right

            delegate: ItemDelegate {
                property bool existNode: false
                id: item
                width: parent.width
                text: title
                font.pixelSize: 20
                onClicked: {

                    //bug#8 замена index на index из model_job
                    updateLeftNodesGraph.connect(graph.onUpdateLeftNodesGraph)
                    updateLeftNodesGraph(title)

                    updateLeftNodesGraph.disconnect(graph.onUpdateLeftNodesGraph)

                    if (!existNodeMode && !existNode) {
                        existNode = true
                        //????
//                        if (!graph.editingMode) {
//                            graph.editingMode = true
//                        }

//                            if(graph.searchRightNodesMode)
//                                graph.searchRightNodesMode = false

                    }

                    if (existNodeMode) {
                        existNode = existNodeMode

                        if (!graph.editingMode) {
                            graph.editingMode = true
                            graph.visibleGraphMode = true
                        }

                        if(!graph.searchRightNodesMode)
                            graph.searchRightNodesMode = true

                        showJobs.close()
                    }
                }

                ToolTip {
                    parent: item
                    leftMargin: pointer_mainWindow.width / 2 - width / 2
                    topMargin: pointer_mainWindow.height - height * 2
                    visible: item.pressed && existNode
                    text: "Такая специльность уже добавлена"
                    timeout: 5000
                }
            }

            model: db_model_jobs_filter

            ScrollIndicator.vertical: ScrollIndicator { }
        }
    }

    Drawer {
        id: showWorks
        edge: Qt.RightEdge
        width: Math.min(pointer_mainWindow.width, pointer_mainWindow.height) / 3 * 2
        height: pointer_mainWindow.height
        dragMargin: 0
        Flickable {
            id: fullInfo
            anchors.fill: parent
            contentWidth: parent.width
            contentHeight: {
                (labelText.height + labelTextfio.height +
                 labelTextadress.height + infoSex.height + infoAge.height
                 + delimiter.height * 4 + 360) < parent.height ? parent.height :
                    parent.height + Math.max(labelText.height,labelTextfio.height,labelTextadress.height)
            }
            flickableDirection: Flickable.VerticalFlick

            Row {
                id: infoFio
                spacing: 10
                anchors.top: parent.top
                anchors.topMargin: 40
                anchors.left: parent.left
                anchors.leftMargin: 40
                anchors.right: parent.right
                anchors.rightMargin: 40

                Label {
                    id: labelTagfio
                    color: Material.color(Material.BlueGrey)
                    wrapMode: Label.Wrap
                    font.pixelSize: 20
                    text: "ФИО: "
                }

                Label {
                    id: labelTextfio
                    wrapMode: Label.Wrap
                    font.pixelSize: 20
                    width: infoFio.width - labelTagfio.width
                    //text: "Джанис Локелани Кеиханаикукауакахихулихеекахаунаеле"
                    text: db_model_workers.getFIO(db_model_workers.getIndexById(idInfoWorker))
                }

            }

            Rectangle {
                id: delimiter
                anchors.top: infoFio.bottom
                anchors.topMargin: 40
                anchors.left: parent.left
                anchors.leftMargin: 40
                anchors.right: parent.right
                anchors.rightMargin: 40
                height: 2
                color: Material.color(Material.BlueGrey)
                radius: 10
            }

            Row {
                id: infoSex
                spacing: 10
                anchors.top: delimiter.bottom
                anchors.topMargin: 40
                anchors.left: parent.left
                anchors.leftMargin: 40
                anchors.right: parent.right
                anchors.rightMargin: 40

                Label {
                    color: Material.color(Material.BlueGrey)
                    wrapMode: Label.Wrap
                    font.pixelSize: 20
                    text: "Пол: "
                }

                Label {
                    wrapMode: Label.Wrap
                    font.pixelSize: 20
                    text: db_model_workers.getSex(db_model_workers.getIndexById(idInfoWorker))
                }

            }

            Rectangle {
                id: delimiter2
                anchors.top: infoSex.bottom
                anchors.topMargin: 40
                anchors.left: parent.left
                anchors.leftMargin: 40
                anchors.right: parent.right
                anchors.rightMargin: 40
                height: 2
                color: Material.color(Material.BlueGrey)
                radius: 10
            }

            Row {
                id: infoAge
                spacing: 10
                anchors.top: delimiter2.bottom
                anchors.topMargin: 40
                anchors.left: parent.left
                anchors.leftMargin: 40
                anchors.right: parent.right
                anchors.rightMargin: 40

                Label {
                    color: Material.color(Material.BlueGrey)
                    wrapMode: Label.Wrap
                    font.pixelSize: 20
                    text: "Возраст: "
                }

                Label {
                    wrapMode: Label.Wrap
                    font.pixelSize: 20
                    text: db_model_workers.getAge(db_model_workers.getIndexById(idInfoWorker))
                }

            }

            Rectangle {
                id: delimiter3
                anchors.top: infoAge.bottom
                anchors.topMargin: 40
                anchors.left: parent.left
                anchors.leftMargin: 40
                anchors.right: parent.right
                anchors.rightMargin: 40
                height: 2
                color: Material.color(Material.BlueGrey)
                radius: 10
            }

            Row {
                id: infoAdress
                spacing: 10
                anchors.top: delimiter3.bottom
                anchors.topMargin: 40
                anchors.left: parent.left
                anchors.leftMargin: 40
                anchors.right: parent.right
                anchors.rightMargin: 40

                Label {
                    id: labelTagadress
                    color: Material.color(Material.BlueGrey)
                    wrapMode: Label.Wrap
                    font.pixelSize: 20
                    text: "Город: "
                }

                Label {
                    id: labelTextadress
                    wrapMode: Label.Wrap
                    font.pixelSize: 20
                    width: infoAdress.width - labelTagadress.width
                    //text: "Лланвайрпуллгуингиллгогерихуирндробуллллантисилиогого"
                    text: db_model_workers.getAdress(db_model_workers.getIndexById(idInfoWorker))
                }

            }

            Rectangle {
                id: delimiter4
                anchors.top: infoAdress.bottom
                anchors.topMargin: 40
                anchors.left: parent.left
                anchors.leftMargin: 40
                anchors.right: parent.right
                anchors.rightMargin: 40
                height: 2
                color: Material.color(Material.BlueGrey)
                radius: 10
            }

            Row {
                id: infoSpeciality
                spacing: 10
                anchors.top: delimiter4.bottom
                anchors.topMargin: 40
                anchors.left: parent.left
                anchors.leftMargin: 40
                anchors.right: parent.right
                anchors.rightMargin: 40


                Label {
                    id: labelTag
                    color: Material.color(Material.BlueGrey)
                    wrapMode: Label.Wrap
                    font.pixelSize: 20
                    text: "Cпециальность: "
                }

                Label {
                    id: labelText
                    wrapMode: Label.Wrap
                    font.pixelSize: 20
                    width: parent.width - labelTag.width
                    //text: "Программист С++" + "\nМенеджер" + "Web-Программист" + "Web-Программист" + "Web-Программист" + "\nWeb-Программист"
                    text: getSpecialties(idInfoWorker)
                    //text: db_model_workers.getAdress(db_model_workers.getIndexById(idInfoWorker))
                }

            }
        ScrollIndicator.vertical: ScrollIndicator { }
        }
    }
}

