pragma ComponentBehavior: Bound
pragma Singleton
import QtQml
import QtQuick
import Quickshell
import Quickshell.Services.Notifications

Singleton {
    id: root

    property ListModel allNotifications: ListModel {}
    property var onScreenNotifications: ({})

    function getForScreen(output) {
        if (!root.onScreenNotifications[output]) {
            root.onScreenNotifications[output] = listModelComponent.createObject(root);
        }
        return root.onScreenNotifications[output];
    }

    NotificationServer {
        imageSupported: true
        actionsSupported: true
        bodySupported: true
        bodyMarkupSupported: true
        keepOnReload: true

        onNotification: notification => {
            notification.tracked = true;

            const output = NiriService.focusedOutput;
            const notificationObject = notificationObjectComponent.createObject(root, {
                notification: notification,
                output: output,
                timeString: ""
            });
            root.allNotifications.append({
                "value": notificationObject
            });
            root.getForScreen(output).append({
                "value": notificationObject
            });
        }
    }

    Component {
        id: listModelComponent

        ListModel {}
    }

    Component {
        id: notificationObjectComponent

        NotificationObject {
            id: obj
            connections: Connections {
                target: obj.notification

                function onClosed() {
                    obj.copyOnDismiss();

                    for (let i = 0; i < root.allNotifications.count; ++i) {
                        if (root.allNotifications.get(i)?.value === obj) {
                            root.allNotifications.remove(i);
                            break;
                        }
                    }

                    for (const onScreenNotifications of Object.values(root.onScreenNotifications)) {
                        for (let i = 0; i < onScreenNotifications.count; ++i) {
                            if (onScreenNotifications.get(i)?.value === obj) {
                                onScreenNotifications.remove(i);
                                break;
                            }
                        }
                    }
                }
            }
        }
    }
}
