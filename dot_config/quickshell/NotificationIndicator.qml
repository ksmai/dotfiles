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
        buttonText: {
            const parts = [];

            if (Notifications.notifications.count > 0) {
                parts.push(this.notificationIcon);
                parts.push(Notifications.notifications.count);
            } else {
                parts.push(this.noneIcon);
            }

            return parts.join(" ");
        }
    }
}
