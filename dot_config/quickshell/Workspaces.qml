pragma ComponentBehavior: Bound
import Quickshell
import QtQuick

Row {
    id: root

    required property ShellScreen screen

    readonly property color brightYellow: "#fabd2f"
    readonly property color brightOrange: "#fe8019"
    readonly property color brightRed: "#fb4934"
    readonly property color dark1: "#3c3836"
    readonly property color dark3: "#665c54"

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

            backgroundColor: modelData.is_urgent ? root.brightRed : modelData.is_focused ? root.brightOrange : root.brightYellow
            active: modelData.is_active

            onClicked: () => {
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

            contentItem: Row {
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                spacing: 2

                Text {
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    text: btn.workspaceName
                    color: root.dark1
                    font.family: "monospace"
                    font.weight: 700
                    font.pointSize: 12
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                Text {
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    text: btn.separatorIcon
                    color: root.dark1
                    font.family: "monospace"
                    font.weight: 700
                    font.pointSize: 12
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                Repeater {
                    model: ScriptModel {
                        objectProp: "id"
                        values: btn.windows
                    }

                    anchors.top: parent.top
                    anchors.bottom: parent.bottom

                    Text {
                        required property var modelData
                        readonly property bool isActive: modelData.id === btn.modelData.active_window_id

                        anchors.top: parent?.top
                        anchors.bottom: parent?.bottom
                        text: root.icons[modelData.app_id] ?? root.fallbackIcon
                        color: isActive ? root.dark1 : root.dark3
                        font.family: "monospace"
                        font.weight: 700
                        font.pointSize: isActive && btn.windows.length > 1 ? 16 : 12
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter

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
