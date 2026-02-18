import Quickshell.Services.Pipewire
import QtQuick

Item {
    id: root
    readonly property color brightAqua: "#8ec07c"
    readonly property PwNode sink: Pipewire.defaultAudioSink

    implicitWidth: btn.implicitWidth
    implicitHeight: btn.implicitHeight

    PwObjectTracker {
        objects: Pipewire.nodes.values.filter(node => node.audio && !node.isStream)
    }

    PressableButton {
        id: btn
        backgroundColor: root.brightAqua
        buttonText: {
            let icon;
            let text;

            if (root.sink?.audio?.muted ?? true) {
                icon = "󰝟 ";
            } else if (root.sink.audio.volume <= 0.45) {
                icon = "󰕿 ";
            } else if (root.sink.audio.volume <= 0.75) {
                icon = "󰖀 ";
            } else {
                icon = "󰕾 ";
            }

            if (!root.sink?.audio) {
                text = " ";
            } else {
                text = `${(root.sink.audio.volume * 100).toFixed(0)}%`;
            }

            if (root.sink?.audio?.volume > 1.05) {
                text = text.trim() + "  ";
            }

            return `${icon.trim()} ${text.trim()}`;
        }
        pressed: !(root.sink?.audio?.muted ?? true)

        onClicked: () => {
            if (root.sink?.audio) {
                root.sink.audio.muted = !root.sink.audio.muted;
            }
        }
    }
}
