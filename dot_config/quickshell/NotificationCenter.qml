pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

Rectangle {
    id: root
    readonly property real gap: 16
    readonly property real notificationWidth: 400
    readonly property real notificationShadow: 4
    implicitWidth: notificationWidth + notificationShadow + 2 * gap
    radius: 8
    color: ColorService.light1
    border.width: 4
    border.color: ColorService.dark1

    anchors.top: parent.top
    anchors.topMargin: gap
    anchors.bottom: parent.bottom
    anchors.bottomMargin: gap
    anchors.right: parent.right
    anchors.rightMargin: gap

    required property ShellScreen screen
    property bool opened: NotificationService.notificationCenterOpenedOn === screen.name

    transform: Translate {
        id: translate
        x: root.width + root.gap
    }
    visible: false
    signal changed

    onOpenedChanged: {
        if (opened) {
            root.visible = true;
            list.positionViewAtEnd();
            closeAnimation.stop();
            openAnimation.start();
        } else {
            openAnimation.stop();
            closeAnimation.start();
        }
    }

    PropertyAnimation {
        id: openAnimation
        target: translate
        properties: "x"
        to: 0
        duration: 350
        easing.type: Easing.OutBack

        onFinished: {
            root.changed();
        }
    }

    PropertyAnimation {
        id: closeAnimation
        target: translate
        properties: "x"
        to: root.width + root.gap
        duration: 350
        easing.type: Easing.InBack

        onFinished: {
            root.visible = false;
            root.changed();
        }
    }

    RectangularShadow {
        id: shadow
        anchors.fill: root
        offset.x: root.border.width
        offset.y: root.border.width
        radius: root.radius
        blur: 0
        spread: 0
        color: ColorService.dark1
        z: -1
    }

    ColumnLayout {
        id: column
        anchors.fill: root
        anchors.margins: root.gap
        spacing: root.gap

        Flow {
            Layout.fillWidth: true
            spacing: root.gap

            PressableButton {
                height: 40
                fontSize: 16
                backgroundColor: ColorService.bright_red
                text: " 󰌾 "
                onLeftClicked: () => {
                    lock.startDetached();
                }
            }

            Process {
                id: lock
                command: ["sh", "-c", "sleep 0.2 && killall -USR1 swayidle"]
            }

            PressableButton {
                height: 40
                fontSize: 16
                backgroundColor: ColorService.bright_red
                text: " 󰜉 "
                onLeftClicked: () => {
                    reboot.startDetached();
                }
            }

            Process {
                id: reboot
                command: ["shutdown", "-r", "now"]
            }

            PressableButton {
                height: 40
                fontSize: 16
                backgroundColor: ColorService.bright_red
                text: " 󰐥 "
                onLeftClicked: () => {
                    shutdown.startDetached();
                }
            }

            Process {
                id: shutdown
                command: ["shutdown", "now"]
            }
        }

        RowLayout {
            Layout.fillWidth: true

            Text {
                text: "NOTIFICATIONS"
                color: ColorService.dark1
                font.family: "monospace"
                font.pointSize: 12
                font.weight: 700
            }

            Item {
                Layout.fillWidth: true
            }

            PressableButton {
                text: "CLEAR"
                backgroundColor: ColorService.bright_orange
                onLeftClicked: () => {
                    NotificationService.clearAllNotifications();
                    NotificationService.closeNotificationCenter();
                }
            }
        }

        ListView {
            id: list
            model: NotificationService.allNotifications
            Layout.fillWidth: true
            Layout.fillHeight: true
            orientation: ListView.Vertical
            verticalLayoutDirection: ListView.TopToBottom
            spacing: root.gap
            clip: true
            boundsBehavior: Flickable.StopAtBounds

            add: Transition {
                NumberAnimation {
                    property: "yScale"
                    from: 0
                    to: 1
                    duration: 300
                    easing.type: Easing.OutCubic
                }
            }

            remove: Transition {
                NumberAnimation {
                    property: "yScale"
                    from: 1
                    to: 0
                    duration: 300
                    easing.type: Easing.OutCubic
                }
            }

            displaced: Transition {
                NumberAnimation {
                    properties: "y"
                    duration: 400
                    easing.type: Easing.OutBounce
                }
            }

            delegate: NotificationBox {
                id: box
                required property NotificationObject modelData
                notificationObject: modelData
                width: root.notificationWidth
                property real yScale: 1
                transform: Scale {
                    yScale: box.yScale
                    origin.y: box.height / 2
                }
            }
        }
    }
}
