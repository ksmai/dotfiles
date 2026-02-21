import QtQuick

Item {
    id: root
    implicitWidth: btn.implicitWidth
    implicitHeight: btn.implicitHeight

    PressableButton {
        id: btn
        readonly property string notificationIcon: "󱅫 ".trim()
        readonly property string noneIcon: "󰂜 ".trim()
        readonly property string dndNotificationIcon: "󰂠 ".trim()
        readonly property string dndNoneIcon: "󰪓 ".trim()
        readonly property string inhibitedNotificationIcon: "󰂛 ".trim()
        readonly property string inhibitedNoneIcon: "󰪑 ".trim()

        backgroundColor: "#d3869b"
        text: {
            const parts = [];

            if (NotificationService.notifications.count > 0) {
                parts.push(this.notificationIcon);
                parts.push(NotificationService.notifications.count);
            } else {
                parts.push(this.noneIcon);
            }

            return parts.join(" ");
        }
    }
}
