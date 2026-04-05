pragma ComponentBehavior: Bound
import QtQuick
import Quickshell.Io

PressableButton {
    id: root

    property string cpuTempC: "0"
    property string cpuLoad: "0"
    property string memUsage: "0"
    property string diskUsage: "0"

    text: ` ${cpuLoad}% ${cpuTempC}°C  ${memUsage}%  ${diskUsage}`
    backgroundColor: ColorService.light_red_soft

    Timer {
        interval: 5000
        running: true
        repeat: true

        onTriggered: {
            tempProc.running = true;
            cpuProc.running = true;
        }
    }

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

    Process {
        id: cpuProc
        command: ["sh", "-c", "top -bn1 | grep 'Cpu(s)' | awk '{printf \"%.0f\", $2 + $4}'"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                root.cpuLoad = this.text.trim();
            }
        }
    }

    Process {
        id: memProc
        command: ["sh", "-c", "free | grep Mem | awk '{printf \"%.0f\", $3/$2 * 100}'"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                root.memUsage = this.text.trim();
            }
        }
    }

    Process {
        id: diskProc
        command: ["sh", "-c", "df / | awk 'NR==2 {print $5}'"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                root.diskUsage = this.text.trim();
            }
        }
    }

    Timer {
        interval: 60000
        running: true
        repeat: true
        onTriggered: diskProc.running = true
    }
}
