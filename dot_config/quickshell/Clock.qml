pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell

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

                Layout.fillWidth: true
                locale: Qt.locale("en_US")

                delegate: MonoText {
                    required property var model

                    text: monthGrid.locale.toString(model.date, "d")

                    color: model.today ? ColorService.neutral_orange : model.month === monthGrid.month ? ColorService.dark1 : ColorService.gray
                    font.weight: model.today ? 700 : 400
                }

                function addMonths(months) {
                    const newMonth = monthGrid.month + months;
                    monthGrid.year += Math.floor(newMonth / 12);
                    monthGrid.month = (12 + newMonth % 12) % 12;
                }
            }
        }
    }
}
