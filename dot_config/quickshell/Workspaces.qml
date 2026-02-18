pragma ComponentBehavior: Bound
import Quickshell
import QtQuick

Row {
    id: root
    readonly property color brightYellow: "#fabd2f"
    readonly property color brightOrange: "#fe8019"
    readonly property color brightRed: "#fb4934"
    required property ShellScreen screen

    spacing: 6

    Repeater {
        model: (Niri.workspaces ?? []).filter(ws => ws.output === screen.name)

        delegate: PressableButton {
            required property var modelData

            backgroundColor: modelData.is_urgent ? root.brightRed : modelData.is_focused ? root.brightOrange : root.brightYellow
            buttonText: modelData.name ?? modelData.idx
            active: modelData.is_active
            onClicked: () => {
                Niri.dispatch({
                    "Action": {
                        "FocusWorkspace": {
                            "reference": {
                                "Id": modelData.id
                            }
                        }
                    }
                });
            }
        }
    }
}
