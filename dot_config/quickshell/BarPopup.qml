pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Effects
import Quickshell
import Quickshell.Widgets

PopupWindow {
    id: root
    color: "transparent"
    implicitWidth: rect.implicitWidth + root.borderWidth
    implicitHeight: rect.implicitHeight + root.borderWidth
    visible: false
    property bool visibleBefore: false

    required property Item anchorItem
    required property int anchorY
    readonly property real borderWidth: 4
    readonly property real padding: 8
    readonly property real radius: 8

    property int anchorX: 0
    property Component component: null

    function toggle(component, anchorX) {
        root.visible = false;
        root.anchorX = anchorX;
        if (component && component !== root.component) {
            if (visibleBefore) {
                root.visible = true;
            }
            root.component = component;
        } else {
            root.visible = false;
            root.component = null;
        }
    }

    anchor {
        item: anchorItem
        gravity: Edges.Top | Edges.Right
        rect.x: anchorX
        rect.y: anchorY
    }

    WrapperRectangle {
        id: rect
        anchors.fill: parent
        anchors.rightMargin: root.borderWidth
        anchors.bottomMargin: root.borderWidth

        margin: root.padding
        radius: root.radius
        color: ColorService.light1
        border.width: root.borderWidth
        border.color: ColorService.dark1

        child: Loader {
            active: !!root.component
            sourceComponent: root.component

            onLoaded: () => {
                if (root.component && !root.visibleBefore) {
                    root.visibleBefore = true;
                    root.visible = true;
                }
            }
        }
    }

    RectangularShadow {
        anchors.fill: rect
        offset.x: root.borderWidth
        offset.y: root.borderWidth
        radius: root.radius
        blur: 0
        spread: 0
        color: ColorService.dark1
        z: -1
    }
}
