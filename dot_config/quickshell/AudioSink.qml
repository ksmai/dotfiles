import Quickshell.Services.Pipewire
import QtQuick

PressableButton {
    id: root

    readonly property color brightYellow: "#fabd2f"
    readonly property color brightOrange: "#fe8019"
    readonly property PwNode sink: Pipewire.defaultAudioSink

    backgroundColor: active ? brightOrange : brightYellow
    text: {
        const parts = [];

        if (sink?.audio?.muted ?? true) {
            parts.push("󰝟 ");
        } else if (sink.audio.volume <= 0.45) {
            parts.push("󰕿 ");
        } else if (sink.audio.volume <= 0.75) {
            parts.push("󰖀 ");
        } else {
            parts.push("󰕾 ");
        }

        if (!sink?.audio) {
            parts.push(" ");
        } else {
            parts.push(`${(sink.audio.volume * 100).toFixed(0)}%`);
        }

        if (sink?.audio?.volume > 1.05) {
            parts.push(" ");
        }

        return parts.map(part => part.trim()).join(" ");
    }
    active: !(sink?.audio?.muted ?? true)

    onClicked: () => {
        if (sink?.audio) {
            sink.audio.muted = !sink.audio.muted;
        }
    }

    PwObjectTracker {
        objects: {
            if (!Pipewire.ready || !Pipewire.nodes?.values) {
                return [];
            }
            return Pipewire.nodes.values.filter(node => node && node.audio && !node.isStream && node.isSink);
        }
    }
}
