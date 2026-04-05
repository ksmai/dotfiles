pragma ComponentBehavior: Bound
import Quickshell
import QtQuick

Row {
    id: root

    required property ShellScreen screen

    readonly property var icons: {
        "kitty": " ".trim(),
        "firefox": " ".trim(),
        "org.kde.kmines": "󰷚 ".trim(),
        "signal": "󰭹 ".trim(),
        "org.telegram.desktop": " ".trim(),
        "io.mgba.mGBA": "󱎓 ".trim(),
        "org.keepassxc.KeePassXC": " ".trim(),
        "calibre-gui": " ".trim(),
        "org.pulseaudio.pavucontrol": " ".trim(),
        "VirtualBox": " ".trim(),
        "thunar": "󰱼 ".trim(),
        "gimp": " ".trim(),
        "chromium": " ".trim()
    }
    readonly property string fallbackIcon: " ".trim()
    readonly property string separatorIcon: "󰅂 ".trim()

    spacing: 6

    Repeater {
        model: ScriptModel {
            objectProp: "id"
            values: (NiriService.workspaces ?? []).filter(ws => ws.output === screen.name)
        }

        delegate: PressableButton {
            id: btn
            required property var modelData
            readonly property string workspaceName: modelData.name ?? modelData.idx
            readonly property string separatorIcon: windows.length > 0 ? root.separatorIcon : ""
            readonly property list<var> windows: NiriService.windows.filter(w => w && w.workspace_id && w.workspace_id === modelData?.id)

            backgroundColor: modelData.is_urgent ? ColorService.bright_red : modelData.is_focused ? ColorService.bright_orange : ColorService.bright_yellow
            active: modelData.is_active

            onLeftClicked: () => {
                NiriService.dispatch({
                    "Action": {
                        "FocusWorkspace": {
                            "reference": {
                                "Id": modelData.id
                            }
                        }
                    }
                });
            }

            onWheel: wheel => {
                let delta = 1;
                if (wheel.angleDelta.y > 0) {
                    delta = -1;
                }

                let focused = btn.windows.findIndex(w => w.is_focused);
                if (focused === -1) {
                    return;
                }

                focused += delta;
                if (focused < 0 || focused > btn.windows.length - 1) {
                    return;
                }

                NiriService.dispatch({
                    "Action": {
                        "FocusWindow": {
                            "id": btn.windows[focused].id
                        }
                    }
                });
            }

            Row {
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                spacing: 2

                MonoText {
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    text: btn.workspaceName
                }

                MonoText {
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    text: btn.separatorIcon
                }

                Repeater {
                    model: ScriptModel {
                        objectProp: "id"
                        values: btn.windows
                    }

                    anchors.top: parent.top
                    anchors.bottom: parent.bottom

                    MonoText {
                        required property var modelData
                        readonly property bool isActive: modelData.id === btn.modelData.active_window_id

                        anchors.top: parent?.top
                        anchors.bottom: parent?.bottom
                        text: root.icons[modelData.app_id] ?? root.fallbackIcon
                        color: isActive ? ColorService.dark1 : ColorService.dark3
                        font.pointSize: isActive && btn.windows.length > 1 ? 16 : 12

                        TapHandler {
                            onTapped: {
                                NiriService.dispatch({
                                    "Action": {
                                        "FocusWindow": {
                                            "id": parent.modelData.id
                                        }
                                    }
                                });
                            }
                        }
                    }
                }
            }
        }
    }
}
