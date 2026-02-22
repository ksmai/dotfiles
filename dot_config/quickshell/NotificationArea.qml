pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Services.Notifications

Item {
    id: root

    required property ShellScreen screen
    property int spacing: 16
    property int hiddenHeight: 14

    implicitWidth: {
        if (repeater.count === 0) {
            return 0;
        }
        return repeater.itemAt(0).implicitWidth;
    }

    implicitHeight: {
        if (repeater.count === 0) {
            return 0;
        }
        return repeater.itemAt(repeater.count - 1).implicitHeight + (repeater.count - 1) * hiddenHeight;
    }

    Repeater {
        id: repeater
        model: ScriptModel {
            objectProp: "notification.id"
            values: NotificationService.onScreenNotifications.filter(x => x.output === screen.name)
        }

        NotificationBox {
            id: box
            required property NotificationObject modelData
            required property int index
            notificationObject: modelData

            transform: Matrix4x4 {
                property real scaleX: 0.95 ** (repeater.count - 1 - box.index)
                property real translateX: box.implicitWidth / 2 * (1 - scaleX)
                property real translateY: box.index * root.hiddenHeight
                matrix: Qt.matrix4x4(scaleX, 0, 0, translateX, 0, 1, 0, translateY, 0, 0, 1, 0, 0, 0, 0, 1)
            }
        }
    }
}
