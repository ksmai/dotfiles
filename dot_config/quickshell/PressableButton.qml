import QtQuick
import QtQuick.Controls
import QtQuick.Effects

MouseArea {
    id: root
    implicitWidth: rect.implicitWidth
    implicitHeight: rect.implicitHeight

    default property alias content: row.data
    property real shadowSize: 3
    property real hoveredOffset: 1
    property alias radius: rect.radius
    property real horizontalPadding: 10
    readonly property color foregroundColor: "#3c3836"
    property alias backgroundColor: rect.color
    property alias text: defaultText.text
    property bool active: false
    property real transitionDuration: 80
    property real removeHoverSlowdown: 8

    hoverEnabled: true

    RectangularShadow {
        id: shadow
        anchors.fill: rect
        offset.x: root.shadowSize
        offset.y: root.shadowSize
        radius: root.radius
        blur: 0
        spread: 0
        color: root.foregroundColor
    }

    Rectangle {
        id: rect
        border.color: root.foregroundColor
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
                color: root.foregroundColor
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
            when: !root.containsMouse && !root.pressed && !root.active
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
            when: root.containsMouse && !root.pressed
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
            when: !root.containsMouse && !root.pressed && root.active
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
