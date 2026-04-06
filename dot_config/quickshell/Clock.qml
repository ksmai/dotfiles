pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects
import Quickshell
import Quickshell.Io

PressableButton {
    id: root

    property var formats: {
        return ["ddd, d MMM hh:mm", "ddd, d MMM hh:mm:ss"];
    }
    property int formatIndex: 0

    signal popupToggled(Component component, int anchorX)

    text: Qt.formatDateTime(clock.date, formats[formatIndex])
    backgroundColor: ColorService.bright_aqua

    onLeftClicked: mouse => {
        popupToggled(popupComponent, Math.floor(mouse.x));
    }

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

    Component {
        id: popupComponent

        GridLayout {
            columns: 4

            MonoText {
                Layout.row: 0
                Layout.column: 0

                text: "󰅁"

                TapHandler {
                    onTapped: {
                        monthGrid.addMonths(-1);
                    }
                }
            }

            MonoText {
                Layout.row: 0
                Layout.column: 1
                Layout.fillWidth: true

                text: `${monthGrid.year} ${monthGrid.locale.monthName(monthGrid.month, Locale.ShortFormat)}`
            }

            MonoText {
                Layout.row: 0
                Layout.column: 2
                text: "󰅂"

                TapHandler {
                    onTapped: {
                        monthGrid.addMonths(1);
                    }
                }
            }

            DayOfWeekRow {
                Layout.row: 1
                Layout.column: 0
                Layout.columnSpan: 3

                locale: Qt.locale("en_US")
                delegate: MonoText {
                    required property string shortName
                    text: shortName
                }
            }

            MonthGrid {
                id: monthGrid

                Layout.row: 2
                Layout.column: 0
                Layout.columnSpan: 3

                property var holidays: []
                property var events: []
                property date startOfMonth: new Date(year, month, 1)
                property date endOfMonth: new Date(year, month + 1, 0)
                property string startOfMonthStr: toDateString(startOfMonth)
                property string endOfMonthStr: toDateString(endOfMonth)

                Layout.fillWidth: true
                locale: Qt.locale("en_US")

                delegate: MonoText {
                    required property var model

                    text: monthGrid.locale.toString(model.date, "d")

                    color: {
                        if (model.month !== monthGrid.month) {
                            return ColorService.gray;
                        }

                        const weekDay = model.date.getDay();
                        if (weekDay === 0 || weekDay == 6) {
                            return ColorService.neutral_red;
                        }
                        if (monthGrid.holidays[model.day - 1]) {
                            return ColorService.neutral_red;
                        }

                        return ColorService.dark1;
                    }

                    font.underline: model.today

                    Loader {
                        anchors.fill: parent
                        active: parent.model.today
                        z: -1

                        sourceComponent: RectangularShadow {
                            anchors.fill: parent
                            radius: 4
                            blur: 0
                            spread: 4
                            color: ColorService.light0_hard
                        }
                    }
                }

                function addMonths(months) {
                    const newMonth = monthGrid.month + months;
                    monthGrid.year += Math.floor(newMonth / 12);
                    monthGrid.month = (12 + newMonth % 12) % 12;
                    monthGrid.holidays = [];
                    listHolidayProc.running = false;
                    listEventProc.running = false;
                    listHolidayProc.running = true;
                    listEventProc.running = true;
                }

                function toDateString(date) {
                    return locale.toString(date, "yyyy-MM-dd");
                }

                Process {
                    id: listHolidayProc
                    running: true
                    command: ["khal", "list", "-a", "holiday", "--json", "title", monthGrid.startOfMonthStr, monthGrid.endOfMonthStr]

                    stdout: StdioCollector {
                        onStreamFinished: {
                            monthGrid.holidays = this.text.split("\n").filter(Boolean).map(line => line != "[]");
                        }
                    }
                }

                Process {
                    id: listEventProc
                    running: true
                    command: ["khal", "list", "--json", "title", "--json", "start-date", "--json", "start-time", "--json", "end-date", "--json", "end-time", "--json", "all-day", "--json", "calendar", monthGrid.startOfMonthStr, monthGrid.endOfMonthStr]

                    stdout: StdioCollector {
                        onStreamFinished: {
                            monthGrid.events = this.text.split("\n").filter(Boolean).reduce((events, line, idx) => {
                                const parsedEvents = JSON.parse(line);
                                const day = idx + 1;

                                if (parsedEvents.length === 0) {
                                    const event = {};
                                    event.idx = idx;
                                    event.empty = true;
                                    events.push(event);
                                } else {
                                    for (const parsed of parsedEvents) {
                                        const startDate = Date.fromLocaleString(monthGrid.locale, parsed["start-date"], "yyyy-MM-dd");
                                        const startsToday = startDate.getDate() === day;
                                        const endDate = Date.fromLocaleString(monthGrid.locale, parsed["end-date"], "yyyy-MM-dd");
                                        const endsToday = endDate.getDate() === day;

                                        const event = {};
                                        event.title = parsed.title;
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
                        }
                    }
                }
            }

            ListView {
                Layout.row: 0
                Layout.column: 3
                Layout.rowSpan: 3
                Layout.preferredWidth: 400
                Layout.fillHeight: true
                Layout.leftMargin: 24

                model: monthGrid.events
                section.property: "idx"

                section.delegate: Rectangle {
                    required property int section
                    readonly property real paddingTop: section > 0 ? 16 : 0
                    readonly property real paddingBottom: 8
                    implicitHeight: sectionText.implicitHeight + paddingTop + paddingBottom

                    MonoText {
                        id: sectionText
                        text: monthGrid.toDateString(new Date(monthGrid.year, monthGrid.month, parent.section + 1))
                        anchors.top: parent.top
                        anchors.topMargin: parent.paddingTop
                    }
                }
                section.labelPositioning: ViewSection.InlineLabels
                spacing: 8
                clip: true

                delegate: Rectangle {
                    required property var model
                    implicitHeight: eventText.implicitHeight + 2 * eventText.anchors.topMargin
                    anchors.left: parent.left
                    anchors.right: parent.right
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
                        id: eventText
                        wrapMode: Text.Wrap
                        horizontalAlignment: Text.AlignLeft
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.topMargin: parent.model.empty ? 2 : 8
                        anchors.leftMargin: 16
                        anchors.rightMargin: 16
                        lineHeight: 1.2

                        text: {
                            if (parent.model.empty) {
                                return "No events";
                            }
                            if (parent.model.allDay) {
                                return `${parent.model.title}`;
                            }
                            return `${parent.model.title}\n${parent.model.startTime}-${parent.model.endTime}`;
                        }

                        color: parent.model.empty ? ColorService.gray : ColorService.dark1
                        font.italic: parent.model.empty
                    }
                }
            }
        }
    }
}
