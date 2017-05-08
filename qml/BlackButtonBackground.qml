import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Rectangle {
    property bool pressed: false

    gradient: Gradient {
        GradientStop {
            //color: pressed ? "#222" : "#333"
            color: pressed ? "#1a1a1a" : "#99958c"
            position: 0
        }
        GradientStop {
            //color: "#222"
            color: "#99958c"
            position: 1
        }
    }
    Rectangle {
        height: 1
        width: parent.width
        anchors.top: parent.top
        color: "#444"
        visible: !pressed
    }
    Rectangle {
        height: 1
        width: parent.width
        anchors.bottom: parent.bottom
        color: "#444"
    }
}
