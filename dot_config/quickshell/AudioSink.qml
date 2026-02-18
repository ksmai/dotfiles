import Quickshell.Services.Pipewire
import QtQuick

Item {
    id: root
    readonly property color brightAqua: "#8ec07c"
    readonly property PwNode sink: Pipewire.defaultAudioSink

    implicitWidth: btn.implicitWidth
    implicitHeight: btn.implicitHeight

    PwObjectTracker {
        objects: {
            if (!Pipewire.ready || !Pipewire.nodes?.values) {
                return [];
            }
            return Pipewire.nodes.values.filter(node => node && node.audio && !node.isStream && node.isSink);
        }
    }

    PressableButton {
        id: btn
        backgroundColor: root.brightAqua
        buttonText: {
            const parts = [];

            if (root.sink?.audio?.muted ?? true) {
                parts.push("󰝟 ");
            } else if (root.sink.audio.volume <= 0.45) {
                parts.push("󰕿 ");
            } else if (root.sink.audio.volume <= 0.75) {
                parts.push("󰖀 ");
            } else {
                parts.push("󰕾 ");
            }

            if (!root.sink?.audio) {
                parts.push(" ");
            } else {
                parts.push(`${(root.sink.audio.volume * 100).toFixed(0)}%`);
            }

            if (root.sink?.audio?.volume > 1.05) {
                parts.push(" ");
            }

            return parts.map(part => part.trim()).join(" ");
        }
        pressed: !(root.sink?.audio?.muted ?? true)

        onClicked: () => {
            if (root.sink?.audio) {
                root.sink.audio.muted = !root.sink.audio.muted;
            }
        }
    }
}
