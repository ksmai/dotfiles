pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
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

        ColumnLayout {
            RowLayout {
                Layout.fillWidth: true

                MonoText {
                    text: "󰅁"

                    TapHandler {
                        onTapped: {
                            monthGrid.addMonths(-1);
                        }
                    }
                }

                MonoText {
                    Layout.fillWidth: true

                    text: `${monthGrid.year} ${monthGrid.locale.monthName(monthGrid.month, Locale.ShortFormat)}`
                }

                MonoText {
                    text: "󰅂"

                    TapHandler {
                        onTapped: {
                            monthGrid.addMonths(1);
                        }
                    }
                }
            }

            DayOfWeekRow {
                Layout.fillWidth: true

                locale: Qt.locale("en_US")
                delegate: MonoText {
                    required property string shortName
                    text: shortName
                }
            }

            MonthGrid {
                id: monthGrid

                property var holidays: []

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
                }

                function addMonths(months) {
                    const newMonth = monthGrid.month + months;
                    monthGrid.year += Math.floor(newMonth / 12);
                    monthGrid.month = (12 + newMonth % 12) % 12;
                    monthGrid.holidays = [];
                    listHolidayProc.running = false;
                    listHolidayProc.running = true;
                }

                function toDateString(date) {
                    return locale.toString(date, "yyyy-MM-dd");
                }

                Process {
                    id: listHolidayProc
                    running: true
                    property string start: monthGrid.toDateString(new Date(monthGrid.year, monthGrid.month, 1))
                    property string end: monthGrid.toDateString(new Date(monthGrid.year, monthGrid.month + 1, 0))
                    command: ["khal", "list", "-a", "holiday", "--json", "title", start, end]

                    stdout: StdioCollector {
                        onStreamFinished: {
                            monthGrid.holidays = this.text.split("\n").filter(Boolean).map(line => line != "[]");
                        }
                    }
                }
            }
        }
    }
}
