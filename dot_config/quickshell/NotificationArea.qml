pragma ComponentBehavior: Bound
import QtQuick
import Quickshell

Item {
    id: root

    required property ShellScreen screen
    readonly property real spacing: 16

    width: 400

    implicitHeight: {
        const count = repeater.count;
        if (count === 0) {
            return 0;
        }

        let result = 0;
        for (let i = 0; i < count; ++i) {
            result += repeater.itemAt(i)?.implicitHeight ?? 0;
        }
        result += (repeater.count - 1) * spacing;
        result = Math.min(parent.height, result);
        return result;
    }

    readonly property list<real> translateYs: {
        const count = repeater.count;
        if (count === 0) {
            return [];
        }

        const result = [0];
        for (let i = 1; i < count; ++i) {
            result.push(result[i - 1] - spacing - (repeater.itemAt(count - i)?.implicitHeight ?? 0));
        }
        result.reverse();
        return result;
    }

    Repeater {
        id: repeater

        model: NotificationService.getForScreen(root.screen.name)

        delegate: NotificationBox {
            id: box
            required property NotificationObject modelData
            required property int index
            property real translateX: root.width
            property real translateY: root.translateYs[index] ?? 0
            anchors.bottom: root.bottom
            notificationObject: modelData
            width: root.width
            transform: Translate {
                x: box.translateX
                y: box.translateY
            }
            opacity: 0

            states: [
                State {
                    name: "entered"
                    PropertyChanges {
                        box.translateX: 0
                    }
                    PropertyChanges {
                        box.opacity: 1
                    }
                }
            ]

            transitions: [
                Transition {
                    from: ""
                    to: "entered"

                    NumberAnimation {
                        target: box
                        property: "translateX"
                        duration: 300
                        easing.type: Easing.OutBack
                    }
                    NumberAnimation {
                        target: box
                        property: "opacity"
                        duration: 250
                        easing.type: Easing.OutQuad
                    }
                }
            ]

            Behavior on translateY {
                NumberAnimation {
                    duration: 400
                    easing.type: Easing.OutBounce
                }
            }
        }

        onItemAdded: (i, item) => {
            item.state = "entered";
        }

        onItemRemoved: (i, item) => {
            const notificationBox = notificationBoxComponent.createObject(root, {
                notificationObject: item.modelData,
                initialTranslateX: item.translateX,
                initialTranslateY: item.translateY,
                opacity: item.opacity
            });
            notificationBox?.runRemoveAnimation();
        }
    }

    Component {
        id: notificationBoxComponent

        NotificationBox {
            id: removedBox
            readonly property real initialTranslateX: 0
            readonly property real initialTranslateY: 0
            property real translateX: initialTranslateX
            property real translateY: initialTranslateY
            transform: Translate {
                x: removedBox.translateX
                y: removedBox.translateY
            }
            anchors.bottom: root.bottom
            enabled: false
            z: -1

            function runRemoveAnimation() {
                removeAnimation.start();
            }

            SequentialAnimation {
                id: removeAnimation

                function rand(low, high) {
                    return low + (high - low) * Math.random();
                }

                readonly property real upDuration: rand(360, 440)
                readonly property real downDuration: rand(540, 660)
                readonly property real xVelocity: rand(1170, 1430)
                readonly property real yVelocity: rand(1080, 1320)
                readonly property real yAcceleration: rand(2700, 3300)
                readonly property real angularVelocity: rand(45, 55)
                readonly property real scaleVelocity: rand(0.18, 0.22)

                readonly property real t1: upDuration / 1000
                readonly property real x1: removedBox.initialTranslateX - xVelocity * t1
                readonly property real y1: removedBox.initialTranslateY - yVelocity * t1 + 0.5 * yAcceleration * t1 * t1
                readonly property real s1: 1 - scaleVelocity * t1
                readonly property real r1: -angularVelocity * t1

                readonly property real t2: downDuration / 1000
                readonly property real x2: x1 - xVelocity * t2
                readonly property real y2: y1 + 0.5 * yAcceleration * t2 * t2
                readonly property real s2: s1 - scaleVelocity * t2
                readonly property real r2: r1 - angularVelocity * t2

                ParallelAnimation {
                    NumberAnimation {
                        target: removedBox
                        property: "translateX"
                        to: removeAnimation.x1
                        duration: removeAnimation.upDuration
                        easing.type: Easing.Linear
                    }
                    NumberAnimation {
                        target: removedBox
                        property: "translateY"
                        to: removeAnimation.y1
                        duration: removeAnimation.upDuration
                        easing.type: Easing.OutQuad
                    }
                    NumberAnimation {
                        target: removedBox
                        property: "scale"
                        to: removeAnimation.s1
                        duration: removeAnimation.upDuration
                        easing.type: Easing.Linear
                    }
                    NumberAnimation {
                        target: removedBox
                        property: "rotation"
                        to: removeAnimation.r1
                        duration: removeAnimation.upDuration
                        easing.type: Easing.Linear
                    }
                }

                ParallelAnimation {
                    NumberAnimation {
                        target: removedBox
                        property: "translateX"
                        to: removeAnimation.x2
                        duration: removeAnimation.downDuration
                        easing.type: Easing.Linear
                    }
                    NumberAnimation {
                        target: removedBox
                        property: "translateY"
                        to: removeAnimation.y2
                        duration: removeAnimation.downDuration
                        easing.type: Easing.InQuad
                    }
                    NumberAnimation {
                        target: removedBox
                        property: "scale"
                        to: removeAnimation.s2
                        duration: removeAnimation.downDuration
                        easing.type: Easing.Linear
                    }
                    NumberAnimation {
                        target: removedBox
                        property: "rotation"
                        to: removeAnimation.r2
                        duration: removeAnimation.downDuration
                        easing.type: Easing.Linear
                    }
                    NumberAnimation {
                        target: removedBox
                        property: "opacity"
                        to: 0.0
                        duration: removeAnimation.downDuration
                        easing.type: Easing.Linear
                    }
                }

                onFinished: {
                    removedBox.destroy();
                }
            }
        }
    }
}
