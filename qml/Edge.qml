import QtQuick 2.6
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.0

Canvas {
    property var object_1: null
    property var object_2: null

    property color colorEdge: Qt.rgba(1, 0, 0, 1)

    anchors.left: object_1.right
    anchors.right: object_2.left
    anchors.top: object_1.top
    anchors.bottom: object_1.bottom

    onPaint:  {
        var ctx = getContext("2d");
        var x_1 = 0;
        var y_1 = height / 2;
        var x_2 = width - 5;
        var y_2 = height / 2;

        ctx.beginPath();
        ctx.moveTo(x_1,y_1);
        ctx.lineTo(x_2,y_2);
        ctx.moveTo(x_2 + 5, y_2)
        ctx.lineTo(x_2 - 20, y_2 - 10)
        ctx.moveTo(x_2 + 5,y_2)
        ctx.lineTo(x_2 - 20, y_2 + 10)
        ctx.lineWidth = 3;
        ctx.strokeStyle = colorEdge;
        ctx.stroke();
    }
}
