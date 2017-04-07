import QtQuick 2.6
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.0
Pane {
    id: additionArea

    property real indexDeleteNode: -1

    ColumnLayout {
        spacing: 40
        anchors.fill: parent

        Label {

            width: parent.width
            wrapMode: Label.Wrap
            Layout.alignment:  Qt.AlignHCenter
            text: "BusyIndicator is used to indicate activity while content is being loaded,"
                  + " or when the UI is blocked waiting for a resource to become available."
        }
    }

    Drawer {
        id: showJobs
        edge: Qt.RightEdge
        width: Math.min(mainWindow.width, mainWindow.height) / 3 * 2
        height: mainWindow.height
        dragMargin: 10

        Pane {
            id: paneSearch
            focus: true

            TextField {
                id: lifeSearch
                focus: true
                width: showJobs.width - Math.min(imgSearch.width,imgSearch.height) - 20
                placeholderText: "Введите специальность"
                onTextChanged: db_model_jobs.setFilterFixedString(text)
            }

            Image {
                id: imgSearch
                fillMode: Image.Pad
                anchors.left: lifeSearch.right
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

                width: parent.width
                text: title
                  font.pixelSize: 20
                highlighted: ListView.isCurrentItem
                onClicked: {

                    showJobs.close()
                    nav.close()
                }
            }

            model: db_model_jobs

            ScrollIndicator.vertical: ScrollIndicator { }
        }
    }

    Drawer {
        id: showWorks
        edge: Qt.RightEdge
        width: Math.min(mainWindow.width, mainWindow.height) / 3 * 2
        height: mainWindow.height
        dragMargin: 10

        Column {
            id: infoColumn
            spacing: 40
            anchors.top: parent.top
            anchors.topMargin: 40
            anchors.left: parent.left
            anchors.right: parent.right

            Row {
                id: infoFio
                spacing: 10
                anchors.left: parent.left
                anchors.leftMargin: 40

                Label {

                    wrapMode: Label.Wrap
                    font.pixelSize: 20
                    text: "ФИО: "
                }

                Label {
                    wrapMode: Label.Wrap
                    font.pixelSize: 20

                    //text: "Огромный текст Огромный текст Огромный текст Огромный текст Огромный текст мОгромный текст"
                    text: db_model_workers.getFIO(db_model_workers.getIndexById(1))
                }

            }

            Rectangle {
                visible: true
                anchors.left: parent.left
                anchors.leftMargin: 40
                anchors.right: parent.right
                anchors.rightMargin: 40
                height: 2
                color: Material.color(Material.BlueGrey)
                radius: 10
            }

            RowLayout {
                id: infoSex
                spacing: 10
//                anchors.top: parent.top
//                anchors.topMargin: 40
                anchors.left: parent.left
                anchors.leftMargin: 40

                Label {
                    wrapMode: Label.Wrap
                    font.pixelSize: 20
                    text: "Пол: "
                }

                Label {
                    wrapMode: Label.Wrap
                    font.pixelSize: 20

                    //text: "Огромный текст Огромный текст Огромный текст Огромный текст Огромный текст мОгромный текст"
                    text: db_model_workers.getSex(db_model_workers.getIndexById(1))
                }

            }

            Rectangle {
                visible: true
                anchors.left: parent.left
                anchors.leftMargin: 40
                anchors.right: parent.right
                anchors.rightMargin: 40
                height: 2
                color: Material.color(Material.BlueGrey)
                radius: 10
            }

            RowLayout {
                id: infoAge
                spacing: 10
                anchors.left: parent.left
                anchors.leftMargin: 40

                Label {

                    wrapMode: Label.Wrap
                    font.pixelSize: 20
                    text: "Возраст: "
                }

                Label {
                    wrapMode: Label.Wrap
                    font.pixelSize: 20

                    //text: "Огромный текст Огромный текст Огромный текст Огромный текст Огромный текст мОгромный текст"
                    text: db_model_workers.getAge(db_model_workers.getIndexById(1))
                }

            }

            Rectangle {
                visible: true
                anchors.left: parent.left
                anchors.leftMargin: 40
                anchors.right: parent.right
                anchors.rightMargin: 40
                height: 2
                color: Material.color(Material.BlueGrey)
                radius: 10
            }

            RowLayout {
                id: infoAdress
                spacing: 10
                anchors.left: parent.left
                anchors.leftMargin: 40

                Label {

                    wrapMode: Label.Wrap
                    font.pixelSize: 20
                    text: "Город: "
                }

                Label {
                    wrapMode: Label.Wrap
                    font.pixelSize: 20

                    //text: "Огромный текст Огромный текст Огромный текст Огромный текст Огромный текст мОгромный текст"
                    text: db_model_workers.getAdress(db_model_workers.getIndexById(1))
                }

            }

            Rectangle {
                visible: true
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
                anchors.left: parent.left
                anchors.leftMargin: 40
                anchors.right: parent.right
                width: showWorks.availableWidth

                Label {

                    wrapMode: Label.Wrap
                    font.pixelSize: 20
                    text: "Cпециальность: "
                }

                Label {

                    wrapMode: Label.Wrap
                    font.pixelSize: 20
                    text: "Огромный текст Огромный тек"
                    //text: db_model_workers.getSpeciality(db_model_workers.getIndexById(1))
                }

            }
        }
    }
}

