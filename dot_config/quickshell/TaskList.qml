pragma ComponentBehavior: Bound
import QtQuick
import Quickshell.Io
import Quickshell.Widgets

ListView {
    id: root
    readonly property var locale: Qt.locale("en_US")

    model: []
    spacing: 8
    clip: true

    delegate: WrapperRectangle {
        id: wrapper
        required property var model
        required property int index
        width: ListView.view.width
        topMargin: 4
        bottomMargin: 4
        leftMargin: 8
        rightMargin: 8

        radius: 8
        border.color: ColorService.dark1
        border.width: 2
        color: mouseArea.containsMouse ? ColorService.light0_soft : "transparent"

        WrapperMouseArea {
            id: mouseArea
            width: wrapper.width
            cursorShape: Qt.PointingHandCursor
            acceptedButtons: Qt.MiddleButton
            hoverEnabled: true

            onClicked: () => {
                const uuid = wrapper.model.uuid;
                root.model.splice(wrapper.index, 1);
                doneTaskProc.exec({
                    "command": ["task", uuid, "done"]
                });
            }

            Column {
                width: wrapper.width
                spacing: 2

                MonoText {
                    width: parent.width
                    wrapMode: Text.Wrap
                    horizontalAlignment: Text.AlignLeft
                    text: wrapper.model.description
                    font.pointSize: 13
                }

                Loader {
                    active: !!wrapper.model.scheduled
                    width: parent.width
                    sourceComponent: MonoText {
                        width: parent.width
                        wrapMode: Text.Wrap
                        horizontalAlignment: Text.AlignLeft
                        color: {
                            const now = Date.now();
                            if (wrapper.model.scheduled.getTime() < now) {
                                return ColorService.neutral_orange;
                            }
                            return ColorService.gray;
                        }
                        text: root.toDateTimeString(wrapper.model.scheduled)
                    }
                }

                Loader {
                    active: !!wrapper.model.due
                    width: parent.width
                    sourceComponent: MonoText {
                        width: parent.width
                        wrapMode: Text.Wrap
                        horizontalAlignment: Text.AlignLeft
                        color: {
                            const now = Date.now();
                            if (wrapper.model.due.getTime() < now) {
                                return ColorService.neutral_red;
                            }
                            return ColorService.gray;
                        }
                        text: root.toDateTimeString(wrapper.model.due)
                    }
                }
            }
        }
    }

    function toDateTimeString(date) {
        const now = new Date();
        if (date.getFullYear() === now.getFullYear() && date.getMonth() === now.getMonth() && date.getDate() === now.getDate()) {
            return "Today " + locale.toString(date, "hh:mm");
        } else {
            return locale.toString(date, "yyyy-MM-dd hh:mm");
        }
    }

    Process {
        id: listTaskProc
        running: true
        command: ["task", "status:pending", "export"]

        stdout: StdioCollector {
            onStreamFinished: {
                const tasks = JSON.parse(this.text).map(parsed => {
                    const task = {};
                    task.uuid = parsed.uuid;
                    task.description = parsed.description;

                    if (parsed.due) {
                        task.due = Date.fromLocaleString(root.locale, parsed.due, "yyyyMMddThhmmsst");
                    }

                    if (parsed.scheduled) {
                        task.scheduled = Date.fromLocaleString(root.locale, parsed.scheduled, "yyyyMMddThhmmsst");
                    }

                    return task;
                });

                tasks.sort((a, b) => {
                    const aTime = a.scheduled ? a.scheduled.getTime() : a.due ? a.due.getTime() : 0;
                    const bTime = b.scheduled ? b.scheduled.getTime() : b.due ? b.due.getTime() : 0;

                    if (aTime < bTime) {
                        return -1;
                    } else if (aTime > bTime) {
                        return 1;
                    } else {
                        return a.description.localeCompare(b.description) || a.uuid.localeCompare(b.uuid);
                    }
                });

                root.model = tasks;
            }
        }
    }

    Process {
        id: doneTaskProc
        running: false
    }
}
