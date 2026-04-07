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
                Layout.fillWidth: true
                locale: Qt.locale("en_US")

                delegate: MonoText {
                    required property var model

                    text: monthGrid.locale.toString(model.date, "d")

                    color: {
                        if (model.month !== monthGrid.month) {
                            return ColorService.gray;
                        }

                        if (model.date.getDay() === 0 || eventList.hasHoliday(model.day)) {
                            return ColorService.neutral_red;
                        }

                        return ColorService.dark1;
                    }

                    font.underline: model.month === monthGrid.month && eventList.hasEvent(model.day)

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
                    let newMonth = monthGrid.month + months;
                    const newYear = monthGrid.year + Math.floor(newMonth / 12);
                    newMonth = (12 + newMonth % 12) % 12;

                    const now = new Date();
                    let day = 1;
                    if (now.getFullYear() === newYear && now.getMonth() === newMonth) {
                        day = now.getDate();
                    }

                    changeDate(new Date(newYear, newMonth, day));
                }

                Component.onCompleted: {
                    changeDate(new Date());
                }

                onClicked: date => {
                    changeDate(date);
                }

                function changeDate(date) {
                    if (date.getFullYear() !== year || date.getMonth() !== month) {
                        year = date.getFullYear();
                        month = date.getMonth();
                    }
                    eventList.changeDate(date);
                }
            }

            EventList {
                id: eventList
                Layout.row: 0
                Layout.column: 3
                Layout.rowSpan: 3
                Layout.preferredWidth: 400
                Layout.fillHeight: true
                Layout.leftMargin: 24
            }
        }
    }
}
