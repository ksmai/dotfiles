import QtQuick
import Quickshell
import Quickshell.Services.Notifications

ListView {
    id: root

    required property ShellScreen screen

    implicitWidth: contentItem.childrenRect.width + 20
    implicitHeight: 200

    model: ScriptModel {
        objectProp: "notification.id"
        values: NotificationService.onScreenNotifications.filter(x => x.output === screen.name)
    }

    delegate: NotificationBox {
        required property NotificationObject modelData
        notificationObject: modelData
    }
}
