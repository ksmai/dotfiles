pragma Singleton
import QtQml
import QtQuick
import Quickshell
import Quickshell.Services.Notifications

Singleton {
    id: root

    property list<OnScreenNotification> notifications: []
    property list<OnScreenNotification> displayedNotifications: []

    NotificationServer {
        imageSupported: true
        actionsSupported: true
        bodySupported: true
        bodyMarkupSupported: true
        keepOnReload: true

        onNotification: notification => {
            notification.tracked = true;

            const x = comp.createObject(root, {
                notification: notification,
                output: NiriService.focusedOutput
            });

            root.notifications.push(x);
            root.displayedNotifications.push(x);
        }
    }

    Component {
        id: comp

        OnScreenNotification {}
    }
}
