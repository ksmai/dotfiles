pragma ComponentBehavior: Bound

import QtQuick
import Quickshell.Services.Pipewire

Item {
    id: root

    readonly property color brightRed: "#fb4934"

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

    implicitWidth: btn.implicitWidth
    implicitHeight: btn.implicitHeight

    PressableButton {
        id: btn
        backgroundColor: root.brightRed
        visible: !!btn.buttonText

        buttonText: {
            const parts = [];

            if (root.hasAudioInput) {
                parts.push("󰍬 ");
            }

            if (root.hasVideoInput) {
                parts.push("󱒃 ");
            }

            return parts.map(part => part.trim()).join(" ");
        }
    }
}
