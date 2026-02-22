pragma ComponentBehavior: Bound
pragma Singleton
import QtQml
import QtQuick
import Quickshell
import Quickshell.Services.Notifications

Singleton {
    id: root

    property list<NotificationObject> allNotifications: []
    property list<NotificationObject> onScreenNotifications: []

    NotificationServer {
        imageSupported: true
        actionsSupported: true
        bodySupported: true
        bodyMarkupSupported: true
        keepOnReload: true

        onNotification: notification => {
            notification.tracked = true;

            const notificationObject = comp.createObject(root, {
                notification: notification,
                output: NiriService.focusedOutput,
                timeString: ""
            });
            root.allNotifications.push(notificationObject);
            root.onScreenNotifications.push(notificationObject);
        }
    }

    Component {
        id: comp

        NotificationObject {
            id: obj
            connections: Connections {
                target: obj.notification

                function onClosed() {
                    for (let i = 0; i < root.allNotifications.length; ++i) {
                        if (root.allNotifications[i] === obj) {
                            root.allNotifications.splice(i, 1);
                            break;
                        }
                    }

                    for (let i = 0; i < root.onScreenNotifications.length; ++i) {
                        if (root.onScreenNotifications[i] === obj) {
                            root.onScreenNotifications.splice(i, 1);
                            break;
                        }
                    }
                }
            }
        }
    }
}
