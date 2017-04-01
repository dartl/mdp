import QtQuick 2.7
import QtQuick.Controls 1.4

BlackButtonBackground {
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    height: mainWindow.height * 0.08

    signal customizeClicked

    gradient: Gradient {
        GradientStop {
            //color: "#333"
            color: "#99958c"
            position: 0
        }
//        GradientStop {
//            color: "#222"
//            position: 1
//        }
    }

    Button {
        id: menu
        width: parent.height
        height: parent.height
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        iconSource: "qrc:/images/icon-menu.png"
        //onClicked: stackView.pop()
        onClicked: nav.toggle()
        style: BlackButtonStyle {
        }
    }

    Button {
        id: search_specialist
        width: parent.height
        height: parent.height
        anchors.left: menu.right
        anchors.bottom: parent.bottom
        iconSource: "qrc:/images/icon-search-spec.png"
        onClicked: addNode(1)
        style: BlackButtonStyle {
        }
    }

}
