import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Notifications

Scope {
    id: root

    property var notifiedKeys: ({})

    Timer {
        id: pollTimer
        interval: 300000 // 5 minutes
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: taskProcess.running = true
    }

    Process {
        id: taskProcess
        command: ["task", "status:pending", "+OVERDUE", "export"]
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    let tasks = JSON.parse(this.text);
                    root.processOverdueTasks(tasks);
                } catch (e) {
                    console.error("Failed to parse Taskwarrior JSON:", e);
                }
            }
        }
    }

    function processOverdueTasks(tasks) {
        if (!Array.isArray(tasks))
            return;

        tasks.forEach(task => {
            if (!task.id || !task.due)
                return;

            let key = `${task.id}_${task.due}`;

            if (!notifiedKeys[key]) {
                notifiedKeys[key] = true;
                sendNotification(task);
            }
        });
    }

    function sendNotification(task) {
        let summary = 'Task is overdue';
        let body = task.description + "\n" + toDateTimeString(task.due);
        notifyRunner.notify(summary, body);
    }

    function toDateTimeString(date) {
        const locale = Qt.locale("en_US");
        date = Date.fromLocaleString(locale, date, "yyyyMMddThhmmsst");
        const now = new Date();
        if (date.getFullYear() === now.getFullYear() && date.getMonth() === now.getMonth() && date.getDate() === now.getDate()) {
            return "Today " + locale.toString(date, "hh:mm");
        } else {
            return locale.toString(date, "yyyy-MM-dd hh:mm");
        }
    }

    Process {
        id: notifyRunner
        running: false

        function notify(summary, body) {
            notifyRunner.command = ["notify-send", "-i", "task-due", "-u", "critical", summary, body];
            notifyRunner.running = true;
        }
    }
}
