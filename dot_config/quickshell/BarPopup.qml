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
    visible: !!component

    required property Item anchorItem
    required property int anchorY
    readonly property real borderWidth: 4
    readonly property real padding: 8
    readonly property real radius: 8

    property int anchorX: 0
    property Component component: null

    function toggle(component, anchorX) {
        root.anchorX = anchorX;
        root.component = component && component !== root.component ? component : null;
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
