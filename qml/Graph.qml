import QtQuick 2.6
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.0

Pane {
    id: graphView

    ColumnLayout {
        id: layout
        anchors.fill: parent
        spacing: 10
        Label {
            id: labelAdd
            anchors.centerIn: parent
            text: "Нажмите для добавления"
            font.pixelSize: 30
            color: Material.color(Material.Grey)
        }

        MouseArea {
            id: mouse
            anchors.fill: parent
            onClicked: {
                labelAdd.visible = false
                //addJobs.open()
                deleteNode_button.visible = true
                addNode_button.anchors.right = deleteNode_button.left
            }
        }


    }



    Popup {
        id: addJobs
        x: (mainWindow.width - width) / 2
        y: mainWindow.height / 6
        width: Math.min(mainWindow.width, mainWindow.height) / 3 * 1.5
        height: columnJobs.implicitHeight + topPadding + bottomPadding
        modal: true
        focus: true

        contentItem: ColumnLayout {
            id: columnJobs
            Button {
                id: addButton
                text: "Добавить специальность"
                onClicked: {
                    addJobs.close()
                }

                Material.foreground: Material.primary
                Material.background: "transparent"
                Material.elevation: 0

                Layout.preferredWidth: 0
                Layout.fillWidth: true
            }

            Button {
                id: deleteAllButton
                text: "Удалить модель"
                onClicked: {
                    addJobs.close()
                    dialogDeleteModel.open()
                }

                Material.foreground: Material.Red
                Material.background: "transparent"
                Material.elevation: 0

                Layout.preferredWidth: 0
                Layout.fillWidth: true
            }
        }
    }


    Popup {
        id: dialogDeleteModel
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
                text: "Вы уверены?"
                font.pixelSize: 20
                anchors.top: parent.top
                anchors.topMargin: 10
                anchors.horizontalCenter: parent.horizontalCenter
            }

            RowLayout {
                spacing: 10

                Button {
                    id: okButton
                    text: "Ok"
                    onClicked: {
                        dialogDeleteModel.close()
                    }

                    Material.foreground: Material.primary
                    Material.background: "transparent"
                    Material.elevation: 0

                    Layout.fillWidth: true
                }

                Button {
                    id: cancelButton
                    text: "Отмена"
                    onClicked: {
                        dialogDeleteModel.close()
                    }

                    Material.background: "transparent"
                    Material.elevation: 0

                    Layout.fillWidth: true
                }
            }
        }
    }
}

