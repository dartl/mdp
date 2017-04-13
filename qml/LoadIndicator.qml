import QtQuick 2.6
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

Pane {
    id: additionArea

    ColumnLayout {
        spacing: 40
        anchors.fill: parent

        BusyIndicator {
            readonly property int size: Math.min(additionArea.availableWidth, additionArea.availableHeight) / 40
            width: size
            height: size
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
        }
    }
}
