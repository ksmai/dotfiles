import QtQuick

PressableButton {
    id: root
    readonly property string notificationIcon: "󱅫 ".trim()
    readonly property string noneIcon: "󰂜 ".trim()
    readonly property string dndNotificationIcon: "󰂠 ".trim()
    readonly property string dndNoneIcon: "󰪓 ".trim()
    readonly property string inhibitedNotificationIcon: "󰂛 ".trim()
    readonly property string inhibitedNoneIcon: "󰪑 ".trim()

    backgroundColor: "#d3869b"
    text: {
        const parts = [];

        if (NotificationService.notifications.length > 0) {
            parts.push(this.notificationIcon);
            parts.push(NotificationService.notifications.length);
        } else {
            parts.push(this.noneIcon);
        }

        return parts.join(" ");
    }
}
