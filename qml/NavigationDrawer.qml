import QtQuick 2.7
import QtQuick.Window 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Rectangle {
    id: menu_panel

    //property NavigationDrawer
    property bool open: false
    property int position: Qt.LeftEdge

    function show() {open = true;}
    function hide() {open = false;}
    function toggle() {open = open ? false : true;}

    // Внутренние свойства Navigation Drawer
        readonly property bool _rightEdge: position === Qt.RightEdge
        readonly property int _closeX: _rightEdge ? _rootItem.width : - menu_panel.width
        readonly property int _openX: _rightEdge ? _rootItem.width - width : 0
        readonly property int _minimumX: _rightEdge ? _rootItem.width - menu_panel.width : -menu_panel.width
        readonly property int _maximumX: _rightEdge ? _rootItem.width : 0
        readonly property int _pullThreshold: menu_panel.width/2
        readonly property int _slideDuration: 260

        property int _openMarginSize: dp(20)
        property real _velocity: 0
        property real _oldMouseX: -1

        property Item _rootItem: parent

        on_RightEdgeChanged: _setupAnchors()
        onOpenChanged: completeSlideDirection()

        width: (Screen.width > Screen.height) ? dp(320) : Screen.width - dp(56)
        height: parent.height
        x: _closeX
        z: 10

        function _setupAnchors() {
            //_rootItem = parent;

            shadow.anchors.right = undefined;
            shadow.anchors.left = undefined;

            mouse.anchors.left = undefined;
            mouse.anchors.right = undefined;

            if (_rightEdge) {
                mouse.anchors.right = mouse.parent.right;
                shadow.anchors.right = menu_panel.left;
            } else {
                mouse.anchors.left = mouse.parent.left;
                shadow.anchors.left = menu_panel.right;
            }

            slideAnimation.enabled = false;
            menu_panel.x = _rightEdge ? _rootItem.width :  - menu_panel.width;
            slideAnimation.enabled = true;
        }

        function completeSlideDirection() {
            if (open) {
                menu_panel.x = _openX;
            } else {
                menu_panel.x = _closeX;
                Qt.inputMethod.hide();
            }
        }

        function handleRelease() {
            var velocityThreshold = dp(5)
            if ((_rightEdge && _velocity > velocityThreshold) ||
                    (!_rightEdge && _velocity < -velocityThreshold)) {
                menu_panel.open = false;
                completeSlideDirection()
            } else if ((_rightEdge && _velocity < -velocityThreshold) ||
                       (!_rightEdge && _velocity > velocityThreshold)) {
                menu_panel.open = true;
                completeSlideDirection()
            } else if ((_rightEdge && menu_panel.x < _openX + _pullThreshold) ||
                       (!_rightEdge && menu_panel.x > _openX - _pullThreshold) ) {
                menu_panel.open = true;
                menu_panel.x = _openX;
            } else {
                menu_panel.open = false;
                menu_panel.x = _closeX;
            }
        }

        function handleClick(mouse) {
            if ((_rightEdge && mouse.x < menu_panel.x ) || mouse.x > menu_panel.width) {
                open = false;
            }
        }

        onPositionChanged: {
            if (!(position === Qt.RightEdge || position === Qt.LeftEdge )) {
                console.warn("Slidemenu_panel: Unsupported position.")
            }
        }

        Behavior on x {
            id: slideAnimation
            enabled: !mouse.drag.active
            NumberAnimation {
                duration: _slideDuration
                easing.type: Easing.OutCubic
            }
        }

        NumberAnimation on x {
            id: holdAnimation
            to: _closeX + (_openMarginSize * (_rightEdge ? -1 : 1))
            running : false
            easing.type: Easing.OutCubic
            duration: 200
        }

        MouseArea {
            id: mouse
            parent: _rootItem

            y: _rootItem.y
            width: open ? _rootItem.width : _openMarginSize
            height: _rootItem.height
            onPressed:  if (!open) holdAnimation.restart();
            onClicked: handleClick(mouse)
            drag.target: menu_panel
            drag.minimumX: _minimumX
            drag.maximumX: _maximumX
            drag.axis: Qt.Horizontal
            drag.onActiveChanged: if (active) holdAnimation.stop()
            onReleased: handleRelease()
            z: open ? 1 : 0
            onMouseXChanged: {
                _velocity = (mouse.x - _oldMouseX);
                _oldMouseX = mouse.x;
            }
        }

        Connections {
            target: _rootItem
            onWidthChanged: {
                slideAnimation.enabled = false
                menu_panel.completeSlideDirection()
                slideAnimation.enabled = true
            }
        }

        Rectangle {
            id: backgroundBlackout
            parent: _rootItem
            anchors.fill: parent
            opacity: 0.5 * Math.min(1, Math.abs(menu_panel.x - _closeX) / _rootItem.width/2)
            color: "black"
        }

        Item {
            id: shadow
            anchors.left: menu_panel.right
            anchors.leftMargin: _rightEdge ? 0 : dp(10)
            height: parent.height

            Rectangle {
                height: dp(10)
                width: menu_panel.height
                rotation: 90
                opacity: Math.min(1, Math.abs(menu_panel.x - _closeX)/ _openMarginSize)
                transformOrigin: Item.TopLeft
                gradient: Gradient{
                    GradientStop { position: _rightEdge ? 1 : 0 ; color: "#00000000"}
                    GradientStop { position: _rightEdge ? 0 : 1 ; color: "#2c000000"}
                }
            }
        }
}
