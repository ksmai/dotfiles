import QtQuick
import Quickshell.Io

Item {
    id: root
    property alias path: socket.path
    property alias parser: socket.parser
    property int reconnectBaseMs: 400
    property int reconnectMaxMs: 15000
    property int _reconnectAttempts: 0

    onPathChanged: () => {
        socket.connected = false;
        root._reconnectAttempts = 0;
        reconnectTimer.stop();

        if (path) {
            Qt.callLater(() => socket.connected = true);
        }
    }

    signal connected
    signal disconnected

    Socket {
        id: socket

        onConnectedChanged: () => {
            if (this.connected) {
                root.connected();
                root._reconnectAttempts = 0;
                reconnectTimer.stop();
            } else {
                root.disconnected();

                if (root.path) {
                    root._scheduleReconnect();
                }
            }
        }
    }

    Timer {
        id: reconnectTimer

        onTriggered: {
            if (root.path) {
                socket.connected = true;
            }
        }
    }

    function send(data) {
        if (!socket.connected) {
            return;
        }

        const json = typeof data === "string" ? data : JSON.stringify(data);
        const message = json.endsWith("\n") ? json : json + "\n";
        socket.write(message);
        socket.flush();
    }

    function _scheduleReconnect() {
        const pow = Math.min(root._reconnectAttempts, 10);
        const base = Math.min(root.reconnectBaseMs * Math.pow(2, pow), root.reconnectMaxMs);
        const jitter = Math.floor(Math.random() * base / 4);
        reconnectTimer.interval = base + jitter;
        reconnectTimer.restart();
        root._reconnectAttempts += 1;
    }
}
