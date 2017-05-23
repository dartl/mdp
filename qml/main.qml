import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0
import Qt.labs.settings 1.0
import QtQuick.Dialogs 1.2

ApplicationWindow {
    signal usedMenu(int index, string url)

    signal updateRightNodesGraph

    property var addArea_pointer: null

    visible: true
    id: mainWindow
    objectName: "mainWindow"
    width: 1000
    height: 600
    minimumWidth: 900
    minimumHeight: 500
    title: qsTr("Staff Search") + qmlTranslator.emptyString

    Material.theme: Material.Light
    Material.accent: Material.BlueGrey
    Material.primary: Material.BlueGrey

    //flag and path to open file
    property bool isOpenFile : false
    property string pathOpenFile: ""

    //timer for delay simulator
    Timer {
        id:timer
    }

//    delay simulator for LoadIndicator.qml
    function delay(delayTime, cb) {
        timer.interval = delayTime;
        timer.repeat = false;
        timer.triggered.connect(cb);
        timer.start();
    }

    //add slots for Graph.qml
    function onActiveAddArea() {
//        if (stackView.depth !== 0) {
//            if (stackView.currentItem.graph.editingMode) {
//                dialogEditingMode.open()
//                stackView.currentItem.graph.editingMode = false;
//            }
//        }

        stackView.replace(addArea);

        addArea_pointer = stackView.currentItem

        if (!addNode_button.visible)
            addNode_button.visible = true;

        if (!search_button.visible)
            search_button.visible = true;

         addArea_pointer.graph.activeDeleteMode.connect(onActiveDeleteMode);
         addArea_pointer.graph.inActiveDeleteMode.connect(onInActiveDeleteMode);
    }

    //mode in Graph.qml
    function onActiveDeleteMode() {
        if (!stackView.currentItem.graph.deleteMode) {
            deleteNode_button.visible = true;
            addNode_button.anchors.right = deleteNode_button.left;
            stackView.currentItem.graph.deleteMode = true;
        }

        label_delete.text += " (" + stackView.currentItem.graph.deleteNodesList.length + ")"
        //console.log("DeleteNodesList in main.qml " + addArea.graph.deleteNodesList.length)
        //console.log("addArea in main.qml " + addArea_pointer)
        //console.log("stackView in main.qml " + stackView.currentItem)
        console.log("ActiveDeleteMode")
    }

    //mode in Graph.qml
    function onInActiveDeleteMode() {
        if (addArea_pointer.graph.deleteMode) {
            deleteNode_button.visible = false;
            addNode_button.anchors.right = additional_menu.left;
            addArea_pointer.graph.deleteMode = false;
        }

        console.log("InActiveDeleteMode")

    }

    //update text to deleteNode_button
    function onUpdateTextDeleteNodeButton() {
        label_delete.text = qsTr("Delete") + " (" + addArea_pointer.graph.deleteNodesList.length + ")"
    }

    Settings {
        id: settings
        property string language: "Русский"
    }

    header: ToolBar {
        Material.foreground: "white"
        id: toolbar

        RowLayout {
            id: layout
            spacing: 0
            anchors.fill: parent

            ToolButton {
                id: menu_button
                contentItem: Image {
                    fillMode: Image.Pad
                    horizontalAlignment: Image.AlignHCenter
                    verticalAlignment: Image.AlignVCenter
                    source: "qrc:/images/ic-menu.png"
                }
                onClicked: {
                    nav.open()
                    qmlTranslator.emptyString
                }
            }

            ToolButton {
                id: search_button
                visible: false
                anchors.left: menu_button.right
                contentItem: Image {
                    fillMode: Image.Pad
                    horizontalAlignment: Image.AlignHCenter
                    verticalAlignment: Image.AlignVCenter
                    source: "qrc:/images/ic-search-spec.png"
                }
                onClicked: {
                            if (stackView.currentItem.graph.searchRightNodesMode) {
                                stackView.push(loadIndicator)
                                delay(800, function() {
                                    stackView.pop()

                                    updateRightNodesGraph.connect(stackView.currentItem.graph.onUpdateRightNodesGraph)
                                    updateRightNodesGraph()
                                    updateRightNodesGraph.disconnect(stackView.currentItem.graph.onUpdateRightNodesGraph)
                               })

//                                updateRightNodesGraph.connect(stackView.currentItem.graph.onUpdateRightNodesGraph)
//                                updateRightNodesGraph()
//                                updateRightNodesGraph.disconnect(stackView.currentItem.graph.onUpdateRightNodesGraph)
                            }


                }

                ToolTip {
                    parent: search_button
                    leftMargin: mainWindow.width / 2 - width / 2
                    topMargin: mainWindow.height - height * 2
                    visible:  search_button.pressed && !addArea_pointer.graph.searchRightNodesMode
                    text: "Нечего искать!"
                    timeout: 5000
                }
            }

            ToolButton {
                id: addNode_button
                visible: false
                anchors.right: additional_menu.left
                contentItem: Image {
                    fillMode: Image.Pad
                    horizontalAlignment: Image.AlignHCenter
                    verticalAlignment: Image.AlignVCenter
                    source: "qrc:/images/ic-add-node.png"
                }
                onClicked: {
                    stackView.currentItem.drawer_showJobs.open()
                    //stackView.currentItem.graph.editingMode = true
                }
            }

            ToolButton {
                id: deleteNode_button
                visible: false
                anchors.right: additional_menu.left
                contentItem: Image {
                    fillMode: Image.Pad
                    horizontalAlignment: Image.AlignHCenter
                    verticalAlignment: Image.AlignVCenter
                    source: "qrc:/images/ic-delete-node.png"
                }
                onClicked: {
                    optionsDelete.open()
                    onUpdateTextDeleteNodeButton()
                }

                Menu {
                    id: optionsDelete
                    x: mainWindow.width - width
                    y: toolbar.height
                    transformOrigin: Menu.TopRight

                    MenuItem {
                        RowLayout {
                            anchors.centerIn: parent
                            spacing: 10

                            Image {
                                fillMode: Image.Pad
                                source: "qrc:/images/ic-delete-forever.png"
                                horizontalAlignment: Image.AlignHCenter
                                verticalAlignment: Image.AlignVCenter
                            }

                            Label {
                                id: label_delete
                                text: qsTr("Delete") + qmlTranslator.emptyString
                                color: Material.color(Material.Red)
                                font.pixelSize: 20
                                Layout.fillWidth: true
                            }
                        }

                        onTriggered: {
                            addArea_pointer.graph.deleteNodesList.forEach(function(item,i,deleteNodesList){
                                data_graph.removeNode(item.id,item.check)

                                if (!addArea_pointer.graph.searchRightNodesMode) {
                                    if (item.check === false) {
                                        addArea_pointer.graph.searchRightNodesMode = true
                                    }
                                }
                            })
                            addArea_pointer.graph.deleteNodesList.splice(0,
                                                                         addArea_pointer.graph.deleteNodesList.length)

                            addArea_pointer.graph.thisGraph.update()

                            onInActiveDeleteMode()
                        }
                    }
                }
            }

            ToolButton {
                id: additional_menu
                anchors.right: parent.right
                contentItem: Image {
                    fillMode: Image.Pad
                    horizontalAlignment: Image.AlignHCenter
                    verticalAlignment: Image.AlignVCenter
                    source: "qrc:/images/ic-more-vert.png"
                }
                onClicked: optionsMenu.open()

                Menu {
                    id: optionsMenu
                    x: parent.width - width
                    transformOrigin: Menu.TopRight

                    MenuItem {
                        text: qsTr("Settings") + qmlTranslator.emptyString
                        onTriggered: settingsPopup.open()
                    }
                    MenuItem {
                        text: qsTr("About") + qmlTranslator.emptyString
                        onTriggered: {
                            aboutDialog.open()
                    }
                }
            }
        }
    }
}

    Drawer {
        Material.theme: Material.Light
        id: nav
        y: header.height
        width: Math.min(mainWindow.width, mainWindow.height) / 3 * 2
        height: mainWindow.height
        dragMargin: 10

        ListView {
            id: menuView
            interactive: false
            currentIndex: -1
            anchors.fill: parent

            delegate: ItemDelegate {
                width: parent.width

                contentItem: RowLayout {
                    spacing: 10

                    Image {
                        fillMode: Image.Pad
                        source: model.icon
                        horizontalAlignment: Image.AlignHCenter
                        verticalAlignment: Image.AlignVCenter
                    }

                    Label {
                        text: model.title
                        font.pixelSize: 20
                        Layout.fillWidth: true
                    }
                }

                highlighted: ListView.isCurrentItem
                onClicked: {
                    switch(index) {
                    case 0:
                        if (ListView.currentIndex != index) {
                            ListView.currentIndex = index
                            onActiveAddArea()

                            if (stackView.currentItem.graph.visibleGraphMode) {
                                stackView.currentItem.graph.visibleGraphMode = false
                            }

                            nav.close()
                        }


                        break;
                    case 1:
                        if (ListView.currentIndex != index) {
                            ListView.currentIndex = index

                            fileDialog.open()
                        }
                        break;
                    case 2:
                        if (ListView.currentIndex != index) {
                            ListView.currentIndex = index

                            if (!isOpenFile) {
                                saveFileDialog.open()
                            }
                            else {
                                usedMenu(3,pathOpenFile)
                            }
                        }
                        break;
                    case 3:
                        if (ListView.currentIndex != index) {
                            ListView.currentIndex = index

                            saveFileDialog.open()
                        }
                        break;
                    case 4:
                         Qt.quit()
                         break;
                    }
                }
            }
            model: ListModel {
                id: listModel_menu
                ListElement {title: qsTr("Create"); icon: "qrc:/images/icon-create-menu.png"}
                ListElement {title: qsTr("Open"); icon: "qrc:/images/icon-open-menu.png"}
                ListElement {title: qsTr("Save"); icon: "qrc:/images/icon-save-menu.png"}
                ListElement {title: qsTr("Save as"); icon: "qrc:/images/icon-save-as.png"}
                ListElement {title: qsTr("Exit"); icon: "qrc:/images/icon-exit-menu.png"}
            }

            ScrollIndicator.vertical: ScrollIndicator { }
        }
    }

    StackView {
        id: stackView
        anchors.fill: parent

        initialItem: initialPane
    }

    Component {
        id: initialPane
        Pane {
            id: pane

            Label {
                anchors.margins: 20
                anchors.top: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.top
                horizontalAlignment: Label.AlignHCenter
                verticalAlignment: Label.AlignVCenter
                wrapMode: Label.Wrap
                font.pixelSize: 30
                color: Material.color(Material.Grey)
                text: qsTr("Create a new model or open an existing one") + qmlTranslator.emptyString
            }
        }
    }

    Component {
        id: addArea

        AdditionArea {
            pointer_mainWindow: mainWindow
        }
    }

    Component {
        id: loadIndicator

        LoadIndicator {
        }
    }

    Popup {
        id: settingsPopup
        x: (mainWindow.width - width) / 2
        y: mainWindow.height / 6
        width: Math.min(mainWindow.width, mainWindow.height) / 3 * 2
        height: settingsColumn.implicitHeight + topPadding + bottomPadding
        modal: true
        focus: true

        contentItem: ColumnLayout {
            id: settingsColumn
            spacing: 20

            Label {
                text: qsTr("Settings") + qmlTranslator.emptyString
                font.bold: true
            }

            RowLayout {
                spacing: 10

                Label {
                    text: qsTr("Language") + qmlTranslator.emptyString + ":"
                }

                ComboBox {
                    id: styleBox
                    property int languageIndex: -1
                    model: ["Русский", "English"]
                    Component.onCompleted: {
                        languageIndex = find(settings.language, Qt.MatchFixedString)
                        if (languageIndex !== -1)
                            currentIndex = languageIndex
                    }

                    Layout.fillWidth: true
                }
            }

            RowLayout {
                spacing: 10

                Button {
                    id: okButton
                    text: "Ok"
                    onClicked: {
                        settings.language = styleBox.displayText
                        qmlTranslator.setTranslation(settings.language)
                        settingsPopup.close()
                    }

                    Material.foreground: Material.primary
                    Material.background: "transparent"
                    Material.elevation: 0

                    Layout.preferredWidth: 0
                    Layout.fillWidth: true
                }

                Button {
                    id: cancelButton
                    text: qsTr("Cancel") + qmlTranslator.emptyString
                    onClicked: {
                        styleBox.currentIndex = styleBox.languageIndex
                     settingsPopup.close()
                    }

                    Material.background: "transparent"
                    Material.elevation: 0

                    Layout.preferredWidth: 0
                    Layout.fillWidth: true
                }
            }
        }
    }

    Popup {
        id: aboutDialog
        modal: true
        focus: true
        x: (mainWindow.width - width) / 2
        y: mainWindow.height / 6
        width: Math.min(mainWindow.width, mainWindow.height) / 3 * 2
        contentHeight: aboutColumn.height

        Column {
            id: aboutColumn
            spacing: 20

            Label {
                text: qsTr("About application") + qmlTranslator.emptyString
                font.bold: true
            }

            Label {
                width: aboutDialog.availableWidth
                text: qsTr("Staff Search") + qmlTranslator.emptyString
                wrapMode: Label.Wrap
                font.pixelSize: 12
            }

            Label {
                width: aboutDialog.availableWidth
                text: qsTr("The application helps in finding staff") + qmlTranslator.emptyString

                wrapMode: Label.Wrap
                font.pixelSize: 12
            }
        }
    }

    Popup {
        id: dialogEditingMode
        x: (mainWindow.width - width) / 2
        y: mainWindow.height / 6
        width: Math.min(mainWindow.width, mainWindow.height) / 3 * 2
        height: columnInfo.implicitHeight + topPadding + bottomPadding
        modal: true
        focus: true

        contentItem: ColumnLayout {
            id: columnInfo
            spacing: 20
            Label {
                text: qsTr("Save the current model") + qmlTranslator.emptyString + "?"
                font.pixelSize: 20
                anchors.top: parent.top
                anchors.topMargin: 10
                anchors.horizontalCenter: parent.horizontalCenter

                color: Material.color(Material.BlueGrey)
            }

            RowLayout {
                spacing: 10

                Button {
                    id: okButton2
                    text: qsTr("Yes") + qmlTranslator.emptyString
                    onClicked: {
                        dialogEditingMode.close()
                        //open SAVE_WINDOW_IN_WINDOWS OR SIGNAL
                    }

                    Material.foreground: Material.Red
                    Material.background: "transparent"
                    Material.elevation: 0

                    Layout.fillWidth: true
                }

                Button {
                    id: cancelButton2
                    text: qsTr("Cancel") + qmlTranslator.emptyString
                    onClicked: {
                        dialogEditingMode.close()
                    }

                    Material.background: "transparent"
                    Material.elevation: 0

                    Layout.fillWidth: true
                }
            }
        }
    }

    //initial language
    Component.onCompleted: {
        qmlTranslator.setTranslation(settings.language)
    }

    //kludge (horrible piece of shit)/////////////////
    function updateTitlesMenu() {
        listModel_menu.get(0).title = qsTr("Create")
        listModel_menu.get(1).title = qsTr("Open")
        listModel_menu.get(2).title = qsTr("Save")
        listModel_menu.get(3).title = qsTr("Save as")
        listModel_menu.get(4).title = qsTr("Exit")
    }

    Connections {
        target: qmlTranslator
        onLanguageChanged: {
            updateTitlesMenu()
        }
    }
    ////////////////////////////////////////////////

    FileDialog {
        id: fileDialog
        title: qsTr("Please choose a file") + qmlTranslator.emptyString
        folder: shortcuts.desktop
        nameFilters: ["Model files (*.mdp)", "All files (*)"]
        onAccepted: {
            usedMenu(1, fileDialog.fileUrl)
            onActiveAddArea()

            addArea_pointer.graph.visibleGraphMode = true
            addArea_pointer.graph.thisGraph.update()

            isOpenFile = true
            pathOpenFile = fileDialog.fileUrl

            nav.close()
        }
        onRejected: {
            nav.close()
        }
    }

    FileDialog {
        id: saveFileDialog
        title: qsTr("Save as") + qmlTranslator.emptyString
        folder: shortcuts.desktop
        selectExisting: false
        selectMultiple: false
        nameFilters: [ "Model files (*.mdp)", "All files (*)" ]
        onAccepted: {
            usedMenu(3,saveFileDialog.fileUrl)

            nav.close()
        }
        onRejected: {
            nav.close()
        }
    }

}
