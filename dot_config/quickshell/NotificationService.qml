pragma ComponentBehavior: Bound
pragma Singleton
import QtQml
import QtQuick
import Quickshell
import Quickshell.Services.Notifications

Singleton {
    id: root

    property ListModel allNotifications: ListModel {}
    property var _onScreenNotifications: ({})
    property var _paused: ({})
    readonly property real expireTimeout: 60000
    readonly property real minExpireTimeout: 1000

    function getForScreen(output) {
        if (!root._onScreenNotifications[output]) {
            root._onScreenNotifications[output] = listModelComponent.createObject(root);
        }
        return root._onScreenNotifications[output];
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
                timeString: "",
                expiryTime: Date.now() + (notification.expireTimeout >= 0 ? notification.expireTimeout : root.expireTimeout)
            });
            root.allNotifications.append({
                "value": notificationObject
            });
            root.getForScreen(output).append({
                "value": notificationObject
            });
            root.restartTimer();
        }
    }

    function restartTimer() {
        let minTimeout = 0;

        for (const [output, onScreenNotifications] of Object.entries(root._onScreenNotifications)) {
            if (root._paused[output]) {
                continue;
            }
            for (let i = 0; i < onScreenNotifications.count; ++i) {
                if (!minTimeout || onScreenNotifications.get(i)?.value.expiryTime < minTimeout) {
                    minTimeout = onScreenNotifications.get(i)?.value.expiryTime;
                }
            }
        }

        if (!minTimeout) {
            return;
        }

        timer.interval = Math.max(root.minExpireTimeout, minTimeout - Date.now());
        timer.restart();
    }

    function pauseExpiry(output) {
        root._paused[output] = true;
    }

    function resumeExpiry(output) {
        delete root._paused[output];
        restartTimer();
    }

    Timer {
        id: timer
        interval: 0
        running: false
        repeat: false

        onTriggered: {
            const now = Date.now();

            for (const [output, onScreenNotifications] of Object.entries(root._onScreenNotifications)) {
                if (root._paused[output]) {
                    continue;
                }
                for (let i = onScreenNotifications.count - 1; i >= 0; --i) {
                    if (onScreenNotifications.get(i)?.value.expiryTime <= now) {
                        onScreenNotifications.remove(i);
                    }
                }
            }

            root.restartTimer();
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

                    for (const onScreenNotifications of Object.values(root._onScreenNotifications)) {
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
