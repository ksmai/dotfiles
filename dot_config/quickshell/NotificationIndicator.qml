import QtQuick
import Quickshell

PressableButton {
    id: root
    required property ShellScreen screen
    readonly property string notificationIcon: "󱅫 ".trim()
    readonly property string noneIcon: "󰂜 ".trim()
    readonly property string dndNotificationIcon: "󰂠 ".trim()
    readonly property string dndNoneIcon: "󰪓 ".trim()

    backgroundColor: ColorService.bright_purple
    text: {
        const parts = [];

        if (NotificationService.allNotifications.count > 0) {
            parts.push(NotificationService.dnd ? this.dndNotificationIcon : this.notificationIcon);
            parts.push(NotificationService.allNotifications.count);
        } else {
            parts.push(NotificationService.dnd ? this.dndNoneIcon : this.noneIcon);
        }

        return parts.join(" ");
    }

    onLeftClicked: () => {
        NotificationService.toggleNotificationCenter(scope.modelData.name);
    }

    onMiddleClicked: () => {
        NotificationService.toggleDnd();
    }
}
