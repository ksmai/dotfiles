import QtQuick
import QtQuick.Controls
import QtQuick.Effects

Item {
    id: root
    implicitWidth: btn.implicitWidth
    implicitHeight: btn.implicitHeight
    property real shadowSize: 3
    property real hoveredOffset: 1
    property real radius: 8
    property real horizontalPadding: 10
    readonly property color foregroundColor: "#3c3836"
    property color backgroundColor
    property string buttonText
    property bool active: false
    property real transitionDuration: 80
    property real removeHoverSlowdown: 8

    default property Item contentItem: Text {
        text: root.buttonText
        color: root.foregroundColor
        font.family: "monospace"
        font.weight: 700
        font.pointSize: 12
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    signal clicked

    RectangularShadow {
        id: shadow
        anchors.fill: btn
        offset.x: root.shadowSize
        offset.y: root.shadowSize
        radius: root.radius
        blur: 0
        spread: 0
        color: root.foregroundColor
    }

    Button {
        id: btn
        implicitHeight: 30
        horizontalPadding: root.horizontalPadding
        x: 0
        y: 0
        onClicked: () => root.clicked()
        contentItem: root.contentItem

        background: Rectangle {
            id: rect
            anchors.fill: parent
            border.color: root.foregroundColor
            border.width: 2
            color: root.backgroundColor
            radius: root.radius

            Behavior on color {
                PropertyAnimation {
                    duration: root.transitionDuration
                }
            }
        }
    }

    states: [
        State {
            name: "normal"
            when: !btn.hovered && !btn.pressed && !root.active
            PropertyChanges {
                shadow {
                    offset.x: root.shadowSize
                    offset.y: root.shadowSize
                }
                btn {
                    x: 0
                    y: 0
                }
            }
        },
        State {
            name: "hovered"
            when: btn.hovered && !btn.pressed
            PropertyChanges {
                shadow {
                    offset.x: root.shadowSize + root.hoveredOffset
                    offset.y: root.shadowSize + root.hoveredOffset
                }
                btn {
                    x: -root.hoveredOffset
                    y: -root.hoveredOffset
                }
            }
        },
        State {
            name: "active"
            when: !btn.hovered && !btn.pressed && root.active
            PropertyChanges {
                shadow {
                    offset.x: 0
                    offset.y: 0
                }
                btn {
                    x: root.shadowSize
                    y: root.shadowSize
                }
            }
        },
        State {
            name: "pressed"
            when: btn.pressed
            PropertyChanges {
                shadow {
                    offset.x: 0
                    offset.y: 0
                }
                btn {
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
