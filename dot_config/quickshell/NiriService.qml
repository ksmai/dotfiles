pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import QtQml

Singleton {
    id: root
    property list<var> workspaces: []
    property list<var> windows: []
    property string focusedScreen: {
        for (const ws of workspaces) {
            if (ws.is_focused) {
                return ws.output;
            }
        }
        return "";
    }

    AutoReconnectedSocket {
        id: socket
        path: Quickshell.env("NIRI_SOCKET")

        parser: SplitParser {
            onRead: line => {
                try {
                    const event = JSON.parse(line);
                    root._handleEvent(event);
                } catch (e) {
                    console.warn(`Unable to parse line from $NIRI_SOCKET: ${line}: ${e}`);
                }
            }
        }

        onConnected: () => {
            socket.send('"EventStream"');
        }
    }

    AutoReconnectedSocket {
        id: socket2
        path: Quickshell.env("NIRI_SOCKET")
    }

    function dispatch(data) {
        socket2.send(data);
    }

    function _handleEvent(event) {
        const variant = Object.keys(event)[0];
        const data = event[variant];
        let idx;

        switch (variant) {
        case "WorkspacesChanged":
            root.workspaces = data.workspaces;
            root.workspaces.sort((a, b) => {
                return a.idx < b.idx ? -1 : 1;
            });

            break;
        case "WorkspaceUrgencyChanged":
            idx = root.workspaces.findIndex(ws => ws.id === data.id);
            if (idx >= 0) {
                const ws = root.workspaces[idx];
                ws.is_urgent = data.urgent;
            }
            break;
        case "WorkspaceActivated":
            idx = root.workspaces.findIndex(ws => ws.id === data.id);
            const output = root.workspaces[idx]?.output ?? null;
            for (const ws of root.workspaces) {
                if (ws.id === data.id) {
                    ws.is_active = true;
                } else if (ws.output === output) {
                    ws.is_active = false;
                }

                if (data.focused) {
                    ws.is_focused = ws.id === data.id;
                }
            }
            break;
        case "WorkspaceActiveWindowChanged":
            idx = root.workspaces.findIndex(ws => ws.id === data.workspace_id);
            if (idx >= 0) {
                const ws = root.workspaces[idx];
                ws.active_window_id = data.active_window_id;
            }
            break;
        case "WindowsChanged":
            root.windows = data.windows;
            _sortWindows();
            break;
        case "WindowOpenedOrChanged":
            idx = root.windows.findIndex(w => w.id === data.window.id);
            if (idx >= 0) {
                root.windows[idx] = data.window;
            } else {
                root.windows.push(data.window);
            }
            _sortWindows();

            if (data.window.is_focused) {
                for (const w of root.windows) {
                    w.is_focused = w.id === data.window.id;
                }
            }

            break;
        case "WindowClosed":
            idx = root.windows.findIndex(w => w.id === data.id);
            if (idx >= 0) {
                root.windows.splice(idx, 1);
            }
            break;
        case "WindowFocusChanged":
            for (const w of root.windows) {
                w.is_focused = w.id === data.id;
            }
            break;
        case "WindowFocusTimestampChanged":
            idx = root.windows.findIndex(w => w.id === data.id);
            if (idx >= 0) {
                const w = root.windows[idx];
                w.focus_timestamp = data.focus_timestamp;
            }
            break;
        case "WindowUrgencyChanged":
            idx = root.windows.findIndex(w => w.id === data.id);
            if (idx >= 0) {
                const w = root.windows[idx];
                w.is_urgent = data.urgent;
            }
            break;
        case "WindowLayoutsChanged":
            for (const [id, layout] of data.changes) {
                idx = root.windows.findIndex(w => w.id === id);
                if (idx >= 0) {
                    const w = root.windows[idx];
                    w.layout = layout;
                }
            }
            _sortWindows();
            break;
        }
    }

    function _sortWindows() {
        root.windows.sort((a, b) => {
            if (a.layout.pos_in_scrolling_layout && !b.layout.pos_in_scrolling_layout) {
                return -1;
            }
            if (!a.layout.pos_in_scrolling_layout && b.layout.pos_in_scrolling_layout) {
                return 1;
            }
            if (!a.layout.pos_in_scrolling_layout && !b.layout.pos_in_scrolling_layout) {
                return 0;
            }
            if (a.layout.pos_in_scrolling_layout[0] < b.layout.pos_in_scrolling_layout[0]) {
                return -1;
            }
            if (a.layout.pos_in_scrolling_layout[0] > b.layout.pos_in_scrolling_layout[0]) {
                return 1;
            }
            if (a.layout.pos_in_scrolling_layout[1] < b.layout.pos_in_scrolling_layout[1]) {
                return -1;
            }
            if (a.layout.pos_in_scrolling_layout[1] > b.layout.pos_in_scrolling_layout[1]) {
                return 1;
            }
            return 0;
        });
    }
}
