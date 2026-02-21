pragma ComponentBehavior: Bound

import QtQuick
import Quickshell.Services.Pipewire

PressableButton {
    id: root
    backgroundColor: "#fb4934"
    visible: !!text

    text: {
        const parts = [];

        if (root.hasAudioInput) {
            parts.push("󰍬 ".trim());
        }

        if (root.hasVideoInput) {
            parts.push("󱒃 ".trim());
        }

        return parts.join(" ");
    }

    readonly property bool hasAudioInput: {
        if (!Pipewire.ready || !Pipewire.nodes?.values) {
            return false;
        }

        for (const node of Pipewire.nodes.values) {
            if (!node || !node.ready || !node.properties) {
                continue;
            }

            if (node.properties && node.properties["media.class"] === "Stream/Input/Audio") {
                return true;
            }
        }

        return false;
    }

    readonly property bool hasVideoInput: {
        if (!Pipewire.ready || !Pipewire.nodes?.values) {
            return false;
        }

        for (const node of Pipewire.nodes.values) {
            if (!node || !node.ready || !node.properties) {
                continue;
            }

            if (node.properties && node.properties["media.class"] === "Stream/Input/Video") {
                return true;
            }
        }

        return false;
    }

    PwObjectTracker {
        objects: Pipewire.nodes.values
    }
}
