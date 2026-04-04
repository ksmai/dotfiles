pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Io

PressableButton {
    id: root

    property string cpuTempC: "0"

    text: " " + cpuTempC + "°C"
    backgroundColor: ColorService.light_red_soft

    Process {
        id: tempProc
        command: ["cat", "/sys/class/thermal/thermal_zone1/temp"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                root.cpuTempC = (parseInt(text, 10) / 1000).toFixed(0);
            }
        }
    }

    Timer {
        interval: 15000
        running: true
        repeat: true

        onTriggered: {
            tempProc.running = true;
        }
    }
}
