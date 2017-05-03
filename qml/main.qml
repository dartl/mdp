import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0
import Qt.labs.settings 1.0

ApplicationWindow {
    signal usedMenu(int index)

    //???????
    signal getIndexListJobs(string title)
    signal getIndexListWorkers(int index)

    signal updateRightNodesGraph;

    visible: true
    id: mainWindow
    objectName: "mainWindow"
    width: 1000
    height: 600
    title: "Staff Search"

    Material.theme: Material.Light
    Material.accent: Material.BlueGrey
    Material.primary: Material.BlueGrey

    //timer for delay simulator
    Timer {
        id:timer
    }

    //delay simulator for LoadIndicator.qml
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
        if (!addNode_button.visible)
            addNode_button.visible = true;

        if (!search_button.visible)
            search_button.visible = true;

        stackView.currentItem.graph.activeDeleteMode.connect(onActiveDeleteMode);
        stackView.currentItem.graph.inActiveDeleteMode.connect(onInActiveDeleteMode);
        //graph.update()
    }

    //mode in Graph.qml
    function onActiveDeleteMode() {
        if (!stackView.currentItem.graph.deleteMode) {
            deleteNode_button.visible = true;
            addNode_button.anchors.right = deleteNode_button.left;
            stackView.currentItem.graph.deleteMode = true;
        }

        console.log("ActiveDeleteMode")
    }

    //mode in Graph.qml
    function onInActiveDeleteMode() {
        if (stackView.currentItem.graph.deleteMode) {
            deleteNode_button.visible = false;
            addNode_button.anchors.right = additional_menu.left;
            stackView.currentItem.graph.deleteMode = false;
        }

        console.log("InActiveDeleteMode")
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
                onClicked: nav.open()
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
                            //if (stackView.currentItem.existNodeMode) {
                                stackView.push(loadIndicator)
                                delay(1000, function() {
                                    stackView.pop()
                                    stackView.currentItem.existNodeMode = false

                                    updateRightNodesGraph.connect(stackView.currentItem.graph.onUpdateRightNodesGraph)
                                    updateRightNodesGraph()
                                    updateRightNodesGraph.disconnect(stackView.currentItem.graph.onUpdateRightNodesGraph)

                               })
                            //}


                }

                ToolTip {
                    parent: search_button
                    leftMargin: mainWindow.width / 2 - width / 2
                    topMargin: mainWindow.height - height * 2
                    visible:  search_button.pressed && !stackView.currentItem.existNodeMode
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
                    stackView.currentItem.graph.editingMode = true
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
                        text: "Настройки"
                        onTriggered: settingsPopup.open()
                    }
                    MenuItem {
                        text: "О приложении"
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
                            usedMenu(0)
                            onActiveAddArea()

                        }
                        break;
                    case 1:
                        if (ListView.currentIndex != index) {
                            ListView.currentIndex = index
                            usedMenu(1)
                            onActiveAddArea()
                            stackView.currentItem.graph.editingMode = true
                            stackView.currentItem.graph.searchRightNodes = true
                            stackView.currentItem.graph.thisGraph.update()


                        }
                        break;
                    }
                    //usedMenu(index)
                    nav.close()
                }
            }

            model: ListModel {
                ListElement {title: "Создать"; icon: "qrc:/images/icon-create-menu.png"}
                ListElement {title: "Открыть"; icon: "qrc:/images/icon-open-menu.png"}
                ListElement {title: "Сохранить"; icon: "qrc:/images/icon-save-menu.png"}
                ListElement {title: "Сохранить как"; icon: "qrc:/images/icon-save-as.png"}
                ListElement {title: "Выход"; icon: "qrc:/images/icon-exit-menu.png"}
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
                text: "Создайте новую модель или откройте существующую"
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
                text: "Настройки"
                font.bold: true
            }

            RowLayout {
                spacing: 10

                Label {
                    text: "Язык:"
                }

                ComboBox {
                    id: styleBox
                    property int styleIndex: -1
                    model: ["Русский", "English"]
                    Component.onCompleted: {
                        if (styleIndex !== -1)
                            currentIndex = styleIndex
                    }
                    Layout.fillWidth: true
                }
            }

            RowLayout {
                spacing: 10

                Button {
                    id: okButton
                    text: "Ok"
//                    onClicked: {
//                        settings.style = styleBox.displayText
//                        settingsPopup.close()
//                    }

                    Material.foreground: Material.primary
                    Material.background: "transparent"
                    Material.elevation: 0

                    Layout.preferredWidth: 0
                    Layout.fillWidth: true
                }

                Button {
                    id: cancelButton
                    text: "Отмена"
                    onClicked: {
                        styleBox.currentIndex = styleBox.styleIndex
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
                text: "О программе"
                font.bold: true
            }

            Label {
                width: aboutDialog.availableWidth
                text: "Поиск работников"
                wrapMode: Label.Wrap
                font.pixelSize: 12
            }

            Label {
                width: aboutDialog.availableWidth
                text: "Приложение помогает в поиске специалистов"

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
                text: "Сохранить текущую модель?"
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
                    text: "Да"
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
                    text: "Отмена"
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
}
