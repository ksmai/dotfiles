pragma ComponentBehavior: Bound
import QtQuick
import Quickshell

PressableButton {
    text: Qt.formatDateTime(clock.date, "ddd, d MMM hh:mm")
    backgroundColor: "#8ec07c"

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }
}
