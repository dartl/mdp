import QtQuick 2.7
import QtGraphicalEffects 1.0
import QtQuick.Controls 1.4
import QtQuick.Extras 1.4

Rectangle {
    id: additionArea

    //property ControlViewToolBar toolBarHeight: toolBar
    //property alias controlItem: pieMenu

    Item {
        id: controlBoundsItem
        width: parent.width
        height: parent.height
        //подгрузка данного элемента по сигналу
        //visible: false

//        Image {
//            id: bgImage
//            anchors.centerIn: parent
//            height: 48
            Text {
                id: bgLabel
                anchors.top: parent.bottom
                //anchors.topMargin: 50
                anchors.centerIn: parent
                text: "Нажми для взаимодействия"
                color: "#99958c"
                font.pointSize: 20
                font.family: openSans.name
            }
        //}

        MouseArea {
            id: touchArea
            anchors.fill: parent
            onClicked: pieMenu.popup(touchArea.mouseX, touchArea.mouseY)
            //onClicked: {pieMenu.popup(touchArea.mouseX, touchArea.mouseY); bgLabel.text = "";}
            //долгое нажатие
            onPressAndHold: console.log("pressed")
        }

        PieMenu {
            id: pieMenu
            triggerMode: TriggerMode.TriggerOnClick
            width: Math.min(controlBoundsItem.width, controlBoundsItem.height) * 0.5
            height: width

            //style: BlackButtonStyle{}

            MenuItem {
                text: "Добавить"
                onTriggered: {
                    //дейтсвие при нажатии, сигнал создания узлов
                    //bgImage.source = iconSource
                    bgLabel.text = text + "выбрано";
                    showJobs.toggle()
                }
                iconSource: "qrc:/images/icon-addNode-addArea.png"
            }
            MenuItem {
                text: "Добавить1"
                onTriggered: {
                    //дейтсвие при нажатии, сигнал создания узлов
                    //bgImage.source = iconSource
                    bgLabel.text = text + "выбрано"
                    showWorkers.toggle()
                }
                iconSource: "qrc:/images/icon-addNode-addArea.png"
            }
        }
    }
}

