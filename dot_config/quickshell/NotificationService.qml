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
    property string notificationCenterOpenedOn: ""
    readonly property real expireTimeout: 60000
    readonly property real minExpireTimeout: 1000

    function getForScreen(output) {
        if (!_onScreenNotifications[output]) {
            _onScreenNotifications[output] = listModelComponent.createObject(root);
        }
        return _onScreenNotifications[output];
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
                createTime: Date.now(),
                expiryTime: Date.now() + (notification.expireTimeout >= 0 ? notification.expireTimeout : root.expireTimeout)
            });
            root.allNotifications.append({
                "value": notificationObject
            });

            if (!root.notificationCenterOpenedOn) {
                root.getForScreen(output).append({
                    "value": notificationObject
                });
                root.restartTimer();
            }
        }
    }

    function restartTimer() {
        let minTimeout = 0;

        for (const [output, onScreenNotifications] of Object.entries(_onScreenNotifications)) {
            if (_paused[output]) {
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

        timer.interval = Math.max(minExpireTimeout, minTimeout - Date.now());
        timer.restart();
    }

    function pauseExpiry(output) {
        _paused[output] = true;
    }

    function resumeExpiry(output) {
        delete _paused[output];
        restartTimer();
    }

    function toggleNotificationCenter(output) {
        if (notificationCenterOpenedOn === output) {
            closeNotificationCenter();
            return;
        }

        notificationCenterOpenedOn = output;
        clearOnScreenNotifications();
        updateTimeStrings();
    }

    function clearOnScreenNotifications() {
        for (const [output, onScreenNotifications] of Object.entries(_onScreenNotifications)) {
            onScreenNotifications.clear();
        }
    }

    function clearAllNotifications() {
        for (let i = allNotifications.count - 1; i >= 0; --i) {
            allNotifications.get(i)?.value?.dismiss();
        }
    }

    function updateTimeStrings() {
        const now = Date.now();
        for (let i = 0; i < allNotifications.count; ++i) {
            const obj = allNotifications.get(i)?.value;
            if (obj) {
                const timeDiff = now - obj.createTime;
                const days = Math.floor(timeDiff / 1000 / 60 / 60 / 24);
                if (days > 0) {
                    obj.timeString = `${days}d`;
                    continue;
                }

                const hours = Math.floor(timeDiff / 1000 / 60 / 60);
                if (hours > 0) {
                    obj.timeString = `${hours}h`;
                    continue;
                }

                const minutes = Math.floor(timeDiff / 1000 / 60);
                if (minutes > 0) {
                    obj.timeString = `${minutes}m`;
                    continue;
                }

                obj.timeString = "";
            }
        }
    }

    function closeNotificationCenter() {
        notificationCenterOpenedOn = "";
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
                    const obj = onScreenNotifications.get(i)?.value;
                    if (obj?.expiryTime <= now) {
                        obj.expired = true;
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
