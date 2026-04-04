pragma ComponentBehavior: Bound
import QtQuick
import Quickshell

PressableButton {
    id: root

    property var formats: {
        return ["ddd, d MMM hh:mm", "ddd, d MMM hh:mm:ss"];
    }
    property int formatIndex: 0

    text: Qt.formatDateTime(clock.date, formats[formatIndex])
    backgroundColor: ColorService.bright_aqua

    onWheel: wheel => {
        if (wheel.angleDelta.y > 0) {
            if (root.formatIndex === root.formats.length - 1) {
                root.formatIndex = 0;
            } else {
                root.formatIndex += 1;
            }
        } else {
            if (root.formatIndex === 0) {
                root.formatIndex = root.formats.length - 1;
            } else {
                root.formatIndex -= 1;
            }
        }
    }

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }
}
