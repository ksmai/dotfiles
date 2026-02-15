pragma ComponentBehavior: Bound
import QtQuick
import Quickshell

Item {
    implicitWidth: btn.implicitWidth
    implicitHeight: btn.implicitHeight

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }

    PressableButton {
        id: btn
        buttonText: Qt.formatDateTime(clock.date, "ddd, d MMM hh:mm")
        backgroundColor: "#d3869b"
    }
}
