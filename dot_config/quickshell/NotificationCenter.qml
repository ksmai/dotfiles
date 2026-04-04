pragma ComponentBehavior: Bound
import QtQuick
import Quickshell

Rectangle {
    id: root
    implicitWidth: 400
    property real gap: 16
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
    property real translateX: width + gap
    transform: Translate {
        x: root.translateX
    }
    property bool displayed: false

    onOpenedChanged: {
        if (opened) {
            root.displayed = true;
            closeAnimation.stop();
            openAnimation.start();
        } else {
            openAnimation.stop();
            closeAnimation.start();
        }
    }

    NumberAnimation {
        id: openAnimation
        target: root
        properties: "translateX"
        to: 0
    }

    NumberAnimation {
        id: closeAnimation
        target: root
        properties: "translateX"
        to: root.width + root.gap

        onFinished: {
            root.displayed = false;
        }
    }
}
