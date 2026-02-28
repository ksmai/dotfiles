pragma ComponentBehavior: Bound
import QtQuick
import Quickshell

ListView {
    id: root

    required property ShellScreen screen

    implicitWidth: 400
    height: Math.min(parent.height, contentHeight)
    orientation: ListView.Vertical
    verticalLayoutDirection: ListView.BottomToTop
    spacing: 16
    interactive: false

    Component.onCompleted: positionViewAtEnd()

    model: ScriptModel {
        objectProp: "id"
        values: NotificationService.onScreenNotifications.filter(x => x.output === screen.name)
    }

    delegate: NotificationBox {
        id: box
        required property NotificationObject modelData
        property real translateX: 0
        property real translateY: 0
        notificationObject: modelData
        implicitWidth: root.implicitWidth
        transform: Translate {
            x: box.translateX
            y: box.translateY
        }
        opacity: 1.0

        ParallelAnimation {
            id: addAnimation
            NumberAnimation {
                target: box
                property: "translateX"
                from: root.implicitWidth
                to: 0.0
                duration: 300
                easing.type: Easing.OutBack
            }
            NumberAnimation {
                target: box
                property: "opacity"
                from: 0.0
                to: 1.0
                duration: 250
                easing.type: Easing.OutQuad
            }
        }

        SequentialAnimation {
            id: removeAnimation
            readonly property real upDuration: 400
            readonly property real downDuration: 600
            readonly property real xVelocity: 1300
            readonly property real yVelocity: 1200
            readonly property real yAcceleration: 3000
            readonly property real angularVelocity: 50
            readonly property real scaleVelocity: 0.2

            readonly property real t1: upDuration / 1000
            readonly property real x1: -xVelocity * t1
            readonly property real y1: -yVelocity * t1 + 0.5 * yAcceleration * t1 * t1
            readonly property real s1: 1 - scaleVelocity * t1
            readonly property real r1: -angularVelocity * t1

            readonly property real t2: downDuration / 1000
            readonly property real x2: x1 - xVelocity * t2
            readonly property real y2: y1 + 0.5 * yAcceleration * t2 * t2
            readonly property real s2: s1 - scaleVelocity * t2
            readonly property real r2: r1 - angularVelocity * t2

            PropertyAction {
                target: box
                property: "ListView.delayRemove"
                value: true
            }

            ParallelAnimation {
                NumberAnimation {
                    target: box
                    property: "translateX"
                    to: removeAnimation.x1
                    duration: removeAnimation.upDuration
                    easing.type: Easing.Linear
                }
                NumberAnimation {
                    target: box
                    property: "translateY"
                    to: removeAnimation.y1
                    duration: removeAnimation.upDuration
                    easing.type: Easing.OutQuad
                }
                NumberAnimation {
                    target: box
                    property: "scale"
                    to: removeAnimation.s1
                    duration: removeAnimation.upDuration
                    easing.type: Easing.Linear
                }
                NumberAnimation {
                    target: box
                    property: "rotation"
                    to: removeAnimation.r1
                    duration: removeAnimation.upDuration
                    easing.type: Easing.Linear
                }
            }

            ParallelAnimation {
                NumberAnimation {
                    target: box
                    property: "translateX"
                    to: removeAnimation.x2
                    duration: removeAnimation.downDuration
                    easing.type: Easing.Linear
                }
                NumberAnimation {
                    target: box
                    property: "translateY"
                    to: removeAnimation.y2
                    duration: removeAnimation.downDuration
                    easing.type: Easing.InQuad
                }
                NumberAnimation {
                    target: box
                    property: "scale"
                    to: removeAnimation.s2
                    duration: removeAnimation.downDuration
                    easing.type: Easing.Linear
                }
                NumberAnimation {
                    target: box
                    property: "rotation"
                    to: removeAnimation.r2
                    duration: removeAnimation.downDuration
                    easing.type: Easing.Linear
                }
                NumberAnimation {
                    target: box
                    property: "opacity"
                    to: 0.0
                    duration: removeAnimation.downDuration
                    easing.type: Easing.Linear
                }
            }

            PropertyAction {
                target: box
                property: "ListView.delayRemove"
                value: false
            }
        }

        ListView.onAdd: {
            addAnimation.start();
        }

        ListView.onRemove: {
            removeAnimation.start();
        }
    }

    displaced: Transition {
        NumberAnimation {
            properties: "y"
            duration: 400
            easing.type: Easing.OutBounce
        }
        NumberAnimation {
            properties: "opacity"
            to: 1.0
            duration: 300
            easing.type: Easing.Linear
        }
    }
}
