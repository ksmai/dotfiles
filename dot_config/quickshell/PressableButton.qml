import QtQuick
import QtQuick.Effects

Item {
    id: root
    implicitWidth: rect.implicitWidth
    implicitHeight: rect.implicitHeight

    signal wheel(WheelEvent wheel)

    default property alias content: row.data
    property real shadowSize: 3
    property real hoveredOffset: 1
    property alias radius: rect.radius
    property real horizontalPadding: 10
    property alias backgroundColor: rect.color
    property alias text: defaultText.text
    property bool active: false
    property real transitionDuration: 80
    property real removeHoverSlowdown: 8

    property var onLeftClicked
    property var onMiddleClicked
    property var onRightClicked

    property bool pressed: {
        if (!mouseArea.pressed) {
            return false;
        }
        if ((mouseArea.pressedButtons & Qt.LeftButton) && root.onLeftClicked) {
            return true;
        }
        if ((mouseArea.pressedButtons & Qt.MiddleButton) && root.onMiddleClicked) {
            return true;
        }
        if ((mouseArea.pressedButtons & Qt.RightButton) && root.onRightClicked) {
            return true;
        }
        return false;
    }

    property bool hovered: {
        return mouseArea.hoverEnabled && mouseArea.containsMouse;
    }

    RectangularShadow {
        id: shadow
        anchors.fill: rect
        offset.x: root.shadowSize
        offset.y: root.shadowSize
        radius: root.radius
        blur: 0
        spread: 0
        color: ColorService.dark1
    }

    MouseArea {
        id: mouseArea
        anchors.fill: rect
        anchors.rightMargin: -shadow.offset.x
        anchors.bottomMargin: -shadow.offset.y

        acceptedButtons: {
            let buttons = 0;

            if (root.onLeftClicked) {
                buttons |= Qt.LeftButton;
            }

            if (root.onMiddleClicked) {
                buttons |= Qt.MiddleButton;
            }

            if (root.onRightClicked) {
                buttons |= Qt.RightButton;
            }

            return buttons;
        }

        onClicked: mouse => {
            switch (mouse.button) {
            case Qt.LeftButton:
                return root.onLeftClicked?.(mouse);
            case Qt.MiddleButton:
                return root.onMiddleClicked?.(mouse);
            case Qt.RightButton:
                return root.onRightClicked?.(mouse);
            }
        }

        onWheel: wheel => {
            root.wheel(wheel);
        }

        hoverEnabled: !!(root.onLeftClicked || root.onMiddleClicked || root.onRightClicked)
        cursorShape: hoverEnabled ? Qt.PointingHandCursor : Qt.ArrowCursor
    }

    Rectangle {
        id: rect
        border.color: ColorService.dark1
        border.width: 2
        radius: 8
        implicitHeight: 30
        implicitWidth: row.implicitWidth
        x: 0
        y: 0

        Behavior on color {
            PropertyAnimation {
                duration: root.transitionDuration
            }
        }

        Row {
            id: row
            spacing: 4
            leftPadding: root.horizontalPadding
            rightPadding: root.horizontalPadding
            anchors.verticalCenter: parent.verticalCenter
            width: childrenRect.width
            height: childrenRect.height

            Text {
                id: defaultText
                color: ColorService.dark1
                font.family: "monospace"
                font.weight: 700
                font.pointSize: 12
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }
    }

    states: [
        State {
            name: "normal"
            when: !root.hovered && !root.pressed && !root.active
            PropertyChanges {
                shadow {
                    offset.x: root.shadowSize
                    offset.y: root.shadowSize
                }
                rect {
                    x: 0
                    y: 0
                }
            }
        },
        State {
            name: "hovered"
            when: root.hovered && !root.pressed
            PropertyChanges {
                shadow {
                    offset.x: root.shadowSize + root.hoveredOffset
                    offset.y: root.shadowSize + root.hoveredOffset
                }
                rect {
                    x: -root.hoveredOffset
                    y: -root.hoveredOffset
                }
            }
        },
        State {
            name: "active"
            when: !root.hovered && !root.pressed && root.active
            PropertyChanges {
                shadow {
                    offset.x: 0
                    offset.y: 0
                }
                rect {
                    x: root.shadowSize
                    y: root.shadowSize
                }
            }
        },
        State {
            name: "pressed"
            when: root.pressed
            PropertyChanges {
                shadow {
                    offset.x: 0
                    offset.y: 0
                }
                rect {
                    x: root.shadowSize
                    y: root.shadowSize
                }
            }
        }
    ]

    transitions: [
        Transition {
            from: "hovered"
            to: "normal"
            PropertyAnimation {
                properties: "x,y,offset.x,offset.y"
                duration: root.transitionDuration * root.removeHoverSlowdown
            }
        },
        Transition {
            from: "hovered"
            to: "active"
            PropertyAnimation {
                properties: "x,y,offset.x,offset.y"
                duration: root.transitionDuration * root.removeHoverSlowdown
            }
        },
        Transition {
            PropertyAnimation {
                properties: "x,y,offset.x,offset.y"
                duration: root.transitionDuration
            }
        }
    ]
}
