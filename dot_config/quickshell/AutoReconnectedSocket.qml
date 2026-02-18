import QtQuick
import Quickshell.Io

Item {
    id: root
    property alias path: socket.path
    property alias parser: socket.parser
    property int reconnectBaseMs: 400
    property int reconnectMaxMs: 15000
    property int _reconnectAttempts: 0

    signal connected

    function send(data) {
        const json = typeof data === "string" ? data : JSON.stringify(data);
        const message = json.endsWith("\n") ? json : json + "\n";
        socket.write(message);
        socket.flush();
    }

    Socket {
        id: socket
        connected: true

        onConnectedChanged: {
            if (this.connected) {
                root.connected();
                root._reconnectAttempts = 0;
                return;
            }

            const pow = Math.min(root._reconnectAttempts, 10);
            const base = Math.min(root.reconnectBaseMs * Math.pow(2, pow), root.reconnectMaxMs);
            const jitter = Math.floor(Math.random() * base / 4);
            reconnectTimer.interval = base + jitter;
            reconnectTimer.restart();
            root._reconnectAttempts += 1;
        }
    }

    Timer {
        id: reconnectTimer

        onTriggered: {
            if (!socket.connected) {
                socket.connected = true;
            }
        }
    }
}
