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

                Text {
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    text: "󰅁"
                    color: ColorService.dark1
                    font.family: "monospace"
                    font.weight: 700
                    font.pointSize: 12

                    TapHandler {
                        onTapped: {
                            monthGrid.addMonths(-1);
                        }
                    }
                }

                Text {
                    Layout.fillWidth: true

                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    text: `${monthGrid.year} ${monthGrid.locale.monthName(monthGrid.month, Locale.ShortFormat)}`
                    color: ColorService.dark1
                    font.family: "monospace"
                    font.weight: 700
                    font.pointSize: 12
                }

                Text {
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    text: "󰅂"
                    color: ColorService.dark1
                    font.family: "monospace"
                    font.weight: 700
                    font.pointSize: 12

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
                delegate: Text {
                    required property string shortName
                    text: shortName
                    color: ColorService.dark1
                    font.family: "monospace"
                    font.weight: 700
                    font.pointSize: 12
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }

            MonthGrid {
                id: monthGrid

                Layout.fillWidth: true
                locale: Qt.locale("en_US")

                delegate: Text {
                    required property var model

                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    text: monthGrid.locale.toString(model.date, "d")

                    color: model.today ? ColorService.neutral_orange : model.month === monthGrid.month ? ColorService.dark1 : ColorService.gray
                    font.family: "monospace"
                    font.weight: model.today ? 700 : 400
                    font.pointSize: 12
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
