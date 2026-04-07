pragma ComponentBehavior: Bound
import QtQuick
import Quickshell.Io
import Quickshell.Widgets

ListView {
    id: root
    model: []

    readonly property int holidayFlag: 1 << 0
    readonly property int eventFlag: 1 << 1

    readonly property var types: {
        const result = [];

        for (const event of model) {
            while (result.length <= event.idx) {
                result.push(0);
            }

            if (event.empty) {
                continue;
            }

            switch (event.calendar) {
            case "holiday":
                result[event.idx] |= holidayFlag;
                break;
            default:
                result[event.idx] |= eventFlag;
                break;
            }
        }

        return result;
    }

    property int year: 0
    property int month: 0
    property int day: 0
    property date startOfMonth: new Date(year, month, 1)
    property date endOfMonth: new Date(year, month + 1, 0)
    property string startOfMonthStr: toDateString(startOfMonth)
    property string endOfMonthStr: toDateString(endOfMonth)
    readonly property var locale: Qt.locale("en_US")

    section.property: "idx"
    section.delegate: WrapperItem {
        required property int section
        topMargin: section > 0 ? 16 : 0
        bottomMargin: 8

        MonoText {
            text: root.toDateString(new Date(root.year, root.month, parent.section + 1))
            font.pointSize: 13
        }
    }
    section.labelPositioning: ViewSection.InlineLabels
    spacing: 8
    clip: true
    boundsBehavior: Flickable.StopAtBounds

    delegate: WrapperRectangle {
        required property var model
        implicitWidth: ListView.view.width
        topMargin: model.empty ? 0 : 8
        bottomMargin: model.empty ? 0 : 8
        leftMargin: 16
        rightMargin: 16
        radius: 8
        border.color: ColorService.dark1
        border.width: model.empty ? 0 : 2

        color: {
            if (model.empty) {
                return "transparent";
            }
            if (model.calendar === "holiday") {
                return ColorService.bright_red;
            }
            if (model.allDay) {
                return ColorService.bright_orange;
            }
            return ColorService.bright_aqua;
        }

        MonoText {
            wrapMode: Text.Wrap
            horizontalAlignment: Text.AlignLeft
            lineHeight: 1.2
            color: parent.model.empty ? ColorService.gray : ColorService.dark1
            font.italic: !!parent.model.empty
            font.pointSize: 13

            text: {
                if (parent.model.empty) {
                    return "No events";
                }

                const parts = [parent.model.title];

                if (parent.model.description) {
                    parts.push(` ${parent.model.description}`);
                }

                if (parent.model.location) {
                    parts.push(` ${parent.model.location}`);
                }

                if (!parent.model.allDay) {
                    parts.push(` ${parent.model.startTime}-${parent.model.endTime}`);
                }

                if (parts.length > 1) {
                    parts[0] = `󰸘 ${parts[0]}`;
                }

                return parts.join("\n");
            }
        }
    }

    function toDateString(date) {
        return locale.toString(date, "yyyy-MM-dd");
    }

    function jumpToDay() {
        for (let i = 0; i < model.length; ++i) {
            if (model[i].idx === day - 1) {
                positionViewAtIndex(i, ListView.Beginning);
                return;
            }
        }
    }

    function changeDate(date) {
        day = date.getDate();
        if (date.getFullYear() !== year || date.getMonth() !== month) {
            year = date.getFullYear();
            month = date.getMonth();
            model = [];
            listEventProc.running = false;
            listEventProc.running = true;
        } else {
            jumpToDay();
        }
    }

    function hasHoliday(day) {
        const idx = day - 1;
        return types.length > idx && !!(types[idx] & holidayFlag);
    }

    function hasEvent(day) {
        const idx = day - 1;
        return types.length > idx && !!(types[idx] & eventFlag);
    }

    Process {
        id: listEventProc
        running: false
        command: ["khal", "list", "--json", "title", "--json", "start-date", "--json", "start-time", "--json", "end-date", "--json", "end-time", "--json", "all-day", "--json", "calendar", "--json", "description", "--json", "location", root.startOfMonthStr, root.endOfMonthStr]

        stdout: StdioCollector {
            onStreamFinished: {
                root.model = this.text.split("\n").filter(Boolean).reduce((events, line, idx) => {
                    const parsedEvents = JSON.parse(line);
                    const day = idx + 1;

                    if (parsedEvents.length === 0) {
                        const event = {};
                        event.idx = idx;
                        event.empty = true;
                        events.push(event);
                    } else {
                        for (const parsed of parsedEvents) {
                            const startDate = Date.fromLocaleString(root.locale, parsed["start-date"], "yyyy-MM-dd");
                            const startsToday = startDate.getDate() === day;
                            const endDate = Date.fromLocaleString(root.locale, parsed["end-date"], "yyyy-MM-dd");
                            const endsToday = endDate.getDate() === day;

                            const event = {};
                            event.title = parsed.title;
                            event.description = parsed.description;
                            event.location = parsed.location;
                            event.calendar = parsed.calendar;
                            event.idx = idx;

                            if (parsed["all-day"] == "True") {
                                event.allDay = true;
                            } else if (!startsToday && !endsToday) {
                                event.allDay = true;
                            } else if (!endsToday) {
                                event.allDay = false;
                                event.startTime = parsed["start-time"];
                                event.endTime = "24:00";
                            } else if (!startsToday) {
                                event.allDay = false;
                                event.startTime = "00:00";
                                event.endTime = parsed["end-time"];
                            } else {
                                event.allDay = false;
                                event.startTime = parsed["start-time"];
                                event.endTime = parsed["end-time"];
                            }

                            events.push(event);
                        }
                    }
                    return events;
                }, []);

                Qt.callLater(() => {
                    jumpToDay();
                });
            }
        }
    }
}
