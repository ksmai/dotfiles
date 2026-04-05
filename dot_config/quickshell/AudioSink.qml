import Quickshell.Services.Pipewire
import QtQuick

PressableButton {
    id: root

    readonly property PwNode sink: Pipewire.defaultAudioSink

    signal popupToggled(Component component, int anchorX)

    backgroundColor: active ? ColorService.bright_orange : ColorService.bright_yellow
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

    onLeftClicked: mouse => {
        popupToggled(popupComponent, Math.floor(mouse.x));
    }

    onMiddleClicked: () => {
        if (sink?.audio) {
            sink.audio.muted = !sink.audio.muted;
        }
    }

    onWheel: wheel => {
        if (!sink?.ready || !sink?.audio) {
            return;
        }

        let delta = 0.1;
        if (wheel.angleDelta.y < 0) {
            delta *= -1;
        }

        sink.audio.volume = Math.min(1.5, Math.max(0, sink.audio.volume + delta));
    }

    PwObjectTracker {
        objects: {
            if (!Pipewire.ready || !Pipewire.nodes?.values) {
                return [];
            }
            return Pipewire.nodes.values.filter(node => node && node.audio && !node.isStream && node.isSink);
        }
    }

    Component {
        id: popupComponent
        MonoText {
            text: "MIXER"
        }
    }
}
