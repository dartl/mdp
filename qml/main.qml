import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0
import Qt.labs.settings 1.0

ApplicationWindow {
    signal usedMenu(int index)
    signal getIndexListJobs(string title)
    signal getIndexListWorkers(int index)
    signal visiableDelete()



    visible: true
    id: mainWindow
    objectName: "mainWindow"
    width: 1000
    height: 600
    //color: "#cccccc"
    title: "Staff Search"

    /*
      new design
    */

    Material.theme: Material.Light
    Material.accent: Material.BlueGrey
    Material.primary: Material.BlueGrey

    Timer {
        id:timer
    }

    function delay(delayTime, cb) {
        timer.interval = delayTime;
        timer.repeat = false;
        timer.triggered.connect(cb);
        timer.start();
    }


    header: ToolBar {
        Material.foreground: "white"
        id: toolbar

        RowLayout {
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
                anchors.left: menu_button.right
                contentItem: Image {
                    fillMode: Image.Pad
                    horizontalAlignment: Image.AlignHCenter
                    verticalAlignment: Image.AlignVCenter
                    source: "qrc:/images/ic-search-spec.png"
                }
                onClicked: {
                            stackView.replace("qrc:/qml/LoadIndicator.qml")
                            delay(1000, function() {
                               stackView.replace("qrc:/qml/AdditionArea.qml")
                           })
                }
            }

            ToolButton {
                visible: false
                id: addNode_button
                anchors.right: additional_menu.left
                contentItem: Image {
                    fillMode: Image.Pad
                    horizontalAlignment: Image.AlignHCenter
                    verticalAlignment: Image.AlignVCenter
                    source: "qrc:/images/ic-add-node.png"
                }
                onClicked: {
                    //showJobs.open()
                }
            }

            ToolButton {
                visible: false
                id: deleteNode_button
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
                        Layout.fillWidth: true
                    }
                }

                highlighted: ListView.isCurrentItem
                onClicked: {
                    if (index === 0) {
                        if (ListView.currentIndex != index) {
                            ListView.currentIndex = index
                            stackView.replace("qrc:/qml/AdditionArea.qml")
                            addNode_button.visible = true
                        }
                    }

                    usedMenu(index)
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

        initialItem: Pane {
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

}







      /*
        old design
      */
//    property color  fontColor: "#222"
//    property color darkFontColor: "#e7e7e7"
//    //property for graph
//    //property ListModel model_graph: null


//    // Пересчёт независимых от плотности пикселей в физические пиксели устройства
//    readonly property int dpi: Screen.pixelDensity * 25.4
//    function dp(x){ return (dpi < 120) ? x : x*(dpi/160); }

//    FontLoader {
//        id: openSans
//        source: "qrc:/fonts/OpenSans-Regular.ttf"
//     }

//    Text {
//        id: textSingleton
//    }

//    //костыль-обертка для всех элементов, для грамотного расположения
//    Rectangle {
//        id: workArea
//        anchors.fill: parent

//        ControlViewToolBar {
//            id: toolBar
//        }

//        AdditionArea {
//            id: addArea
//            anchors.top: toolBar.bottom
//            anchors.left: parent.left
//            anchors.right: parent.right
//            anchors.bottom: parent.bottom
//        }

//        NavigationDrawer {
//            id: nav
//            //bug№3
//            _rootItem: addArea
//            anchors.top: toolBar.bottom
//            _openMarginSize: 0
//            //////
//            Rectangle {
//                anchors.fill: parent

//                color: "#99958c"

//                ListView {
//                    clip: true
//                    interactive: false
//                    anchors.fill: parent

//                    //Модель данных для списка меню
//                    model: ListModel {
//                        ListElement {title: "Создать"; icon: "qrc:/images/icon-create-menu.png"}
//                        ListElement {title: "Открыть"; icon: "qrc:/images/icon-open-menu.png"}
//                        ListElement {title: "Сохранить"; icon: "qrc:/images/icon-save-menu.png"}
//                        ListElement {title: "Сохранить как"; icon: "qrc:/images/icon-save-menu.png"}
//                        ListElement {title: "Выход"; icon: "qrc:/images/icon-exit-menu.png"}
//                    }
//                    delegate: Button {
//                        width: nav.width
//                        height: mainWindow.height * 0.125
//                        text: title
//                        iconSource: icon
//                        style: BlackButtonStyle {
//                        }

//                        onClicked: {
//                            usedMenu(index)
//                        }
//                    }
//                }
//            }
//        }

//        NavigationDrawer {
//            id: showJobs
//            //bug№3
//            _rootItem: addArea
//            anchors.top: toolBar.bottom
//            _openMarginSize: 0
//            position: Qt.RightEdge
//            /////
//            property string titleSearch: "null"

//            Rectangle {
//                anchors.fill: parent
//                color: "#99958c"

//                TextField {
//                    id: livesearch
//                    focus: true
//                    width: nav.width
//                    height: mainWindow.height * 0.125
//                    anchors.top: parent.top
//                    anchors.bottom: listJobs.top
//                    anchors.left: parent.left
//                    anchors.right: parent.right
//                    placeholderText: "Введите специальность для поиска специалиста"
////                    style: BlackButtonStyle {
////                    }
//                    onTextChanged: db_model_jobs.setFilterFixedString(text)
//                }

//                ListView {
//                    id: listJobs
//                    clip: true
//                    //interactive: false
//                    //anchors.fill: parent
//                    anchors.top: livesearch.bottom
//                    anchors.bottom: parent.bottom
//                    anchors.left: parent.left
//                    anchors.right: parent.right


//                    model: db_model_jobs

//                    delegate: Button {

//                        id: delegateListJobs
//                        width: nav.width
//                        height: mainWindow.height * 0.125
//                        text: title
//                        style: BlackButtonStyle {
//                        }

//                        onClicked: {
//                            //console.log(db_model_jobs.get(index));
//                            getIndexListJobs(title);

//                            //console.log(db_model_jobs.data(ListView.currentIndex,id));
//                            //console.log(db_model_jobs.getId(id))
//                            //db_model_jobs.getId(index)
//                        }
//                    }
//                }
//            }
//        }

//        NavigationDrawer {
//            id: showWorkers
//            //bug№3
//            _rootItem: addArea
//            anchors.top: toolBar.bottom
//            _openMarginSize: 0
//            position: Qt.RightEdge
//            /////

//            Rectangle {
//                anchors.fill: parent
//                color: "#99958c"

//                ListView {
//                    id: listWorkers
//                    clip: true
//                    //interactive: false
//                    anchors.fill: parent

//                    model: db_model_workers

//                    delegate: Button {
//                        width: nav.width
//                        height: mainWindow.height * 0.125

//                        text: fio
//                        style: BlackButtonStyle {
//                        }

//                        onClicked: {
//                            getIndexListWorkers(index)
//                        }
//                    }
//                }
//            }
//        }
//    }

