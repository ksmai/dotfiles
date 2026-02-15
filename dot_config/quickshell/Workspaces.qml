pragma ComponentBehavior: Bound
import Quickshell.I3
import QtQuick

Row {
    id: root
    readonly property color brightYellow: "#fabd2f"
    readonly property color brightOrange: "#fe8019"
    readonly property color brightRed: "#fb4934"

    spacing: 6

    Repeater {
        model: I3.workspaces.values.filter(ws => ws.monitor && bar.modelData && ws.monitor.name === bar.modelData.name)

        delegate: PressableButton {
            required property I3Workspace modelData
            backgroundColor: modelData.urgent ? root.brightRed : modelData.focused ? root.brightOrange : root.brightYellow
            buttonText: modelData.name
            pressed: modelData.active
            onClicked: () => I3.dispatch(`workspace number ${modelData.number}`)
        }
    }
}
