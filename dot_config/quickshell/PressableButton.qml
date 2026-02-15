import QtQuick
import QtQuick.Controls
import QtQuick.Effects

Item {
    id: item
    implicitWidth: btn.implicitWidth
    implicitHeight: btn.implicitHeight
    property real shadowSize: 3
    property real radius: 8
    property real horizontalPadding: 10
    readonly property color foregroundColor: "#3c3836"
    property color backgroundColor
    property string buttonText
    property bool pressed: false
    property real transitionDuration: 100
    property var onClicked
    property bool hoverEnabled: true
    default property Item contentItem: Text {
        text: item.buttonText
        color: item.foregroundColor
        font.family: "monospace"
        font.weight: 700
        font.pointSize: 12
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    RectangularShadow {
        id: shadow
        anchors.fill: btn
        offset.x: item.shadowSize
        offset.y: item.shadowSize
        radius: item.radius
        blur: 0
        spread: 0
        color: item.foregroundColor
    }

    Button {
        id: btn
        implicitHeight: 30
        horizontalPadding: item.horizontalPadding
        x: 0
        y: 0
        onClicked: () => item.onClicked && item.onClicked()
        hoverEnabled: item.hoverEnabled
        contentItem: item.contentItem

        background: Rectangle {
            id: rect
            anchors.fill: parent
            border.color: item.foregroundColor
            border.width: 2
            color: item.backgroundColor
            radius: item.radius

            Behavior on color {
                PropertyAnimation {
                    duration: item.transitionDuration
                }
            }
        }
    }

    states: State {
        name: "pressed"
        when: item.pressed || btn.hovered
        PropertyChanges {
            shadow {
                offset.x: 0
                offset.y: 0
            }
            btn {
                x: item.shadowSize
                y: item.shadowSize
            }
        }
    }

    transitions: Transition {
        PropertyAnimation {
            properties: "x,y,offset.x,offset.y"
            duration: item.transitionDuration
        }
    }
}
