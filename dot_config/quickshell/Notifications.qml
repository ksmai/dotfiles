pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.Notifications

Singleton {
    id: root

    property ListModel notifications: ListModel {}
    property ListModel displayedNotifications: ListModel {}

    NotificationServer {
        imageSupported: true
        actionsSupported: true
        bodySupported: true
        bodyMarkupSupported: true
        keepOnReload: true

        onNotification: notification => {
            notification.tracked = true;
            root.notifications.append(notification);
            root.displayedNotifications.append(notification);
        }
    }
}
