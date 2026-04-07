pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Widgets

GridLayout {
    id: root
    columns: 4
    property int selectedYear: 0
    property int selectedMonth: 0

    MonoText {
        Layout.row: 0
        Layout.column: 0

        font.pointSize: 14
        text: "󰅁"
        color: prevYearArea.containsMouse ? ColorService.dark3 : ColorService.dark1

        MouseArea {
            id: prevYearArea
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            hoverEnabled: true
            onClicked: () => {
                if (stack.currentIndex === 0) {
                    monthGrid.addMonths(-1);
                } else {
                    root.selectedYear -= 1;
                }
            }
        }
    }

    MonoText {
        Layout.row: 0
        Layout.column: 1
        Layout.fillWidth: true
        font.pointSize: 14

        text: stack.currentIndex === 0 ? `${monthGrid.year} ${monthGrid.locale.monthName(monthGrid.month, Locale.ShortFormat)}` : `${root.selectedYear}`
        color: selectYearArea.containsMouse ? ColorService.dark3 : ColorService.dark1

        MouseArea {
            id: selectYearArea
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            hoverEnabled: true
            onClicked: () => {
                if (stack.currentIndex === 0) {
                    root.selectedYear = monthGrid.year;
                    root.selectedMonth = monthGrid.month;
                    stack.currentIndex = 1;
                } else {
                    monthGrid.changeDate(new Date(root.selectedYear, root.selectedMonth, 1), true);
                    stack.currentIndex = 0;
                }
            }
        }
    }

    MonoText {
        Layout.row: 0
        Layout.column: 2

        font.pointSize: 14
        text: "󰅂"
        color: nextYearArea.containsMouse ? ColorService.dark3 : ColorService.dark1

        MouseArea {
            id: nextYearArea
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            hoverEnabled: true
            onClicked: () => {
                if (stack.currentIndex === 0) {
                    monthGrid.addMonths(1);
                } else {
                    root.selectedYear += 1;
                }
            }
        }
    }

    StackLayout {
        id: stack
        Layout.row: 1
        Layout.column: 0
        Layout.columnSpan: 3
        Layout.fillWidth: true
        Layout.preferredWidth: 300

        ColumnLayout {
            DayOfWeekRow {
                Layout.fillWidth: true
                locale: Qt.locale("en_US")
                delegate: MonoText {
                    required property string shortName
                    text: shortName
                    font.pointSize: 14
                }
            }

            MonthGrid {
                id: monthGrid
                Layout.fillWidth: true

                locale: Qt.locale("en_US")

                delegate: WrapperRectangle {
                    required property var model
                    radius: 4
                    color: model.today ? ColorService.light0_hard : "transparent"
                    topMargin: 2
                    bottomMargin: 2

                    border.width: model.month === monthGrid.month && eventList.hasEvent(model.day) ? 2 : 0
                    border.color: {
                        if (model.month !== monthGrid.month) {
                            return ColorService.gray;
                        }

                        if (model.date.getDay() === 0 || eventList.hasHoliday(model.day)) {
                            return ColorService.neutral_red;
                        }

                        return ColorService.dark1;
                    }

                    MonoText {
                        text: monthGrid.locale.toString(parent.model.date, "d")
                        color: parent.border.color
                        font.pointSize: 14
                    }
                }

                function addMonths(months) {
                    let newMonth = monthGrid.month + months;
                    const newYear = monthGrid.year + Math.floor(newMonth / 12);
                    newMonth = (12 + newMonth % 12) % 12;
                    changeDate(new Date(newYear, newMonth, 1), true);
                }

                Component.onCompleted: {
                    changeDate(new Date());
                }

                onClicked: date => {
                    changeDate(date);
                }

                function changeDate(date, checksToday) {
                    if (date.getFullYear() !== year || date.getMonth() !== month) {
                        year = date.getFullYear();
                        month = date.getMonth();
                    }

                    const now = new Date();
                    if (checksToday && now.getFullYear() === date.getFullYear() && now.getMonth() === date.getMonth()) {
                        eventList.changeDate(now);
                    } else {
                        eventList.changeDate(date);
                    }
                }
            }
        }

        GridLayout {
            columns: 4

            Repeater {
                model: [
                    {
                        "month": 0,
                        "name": "JAN"
                    },
                    {
                        "month": 1,
                        "name": "FEB"
                    },
                    {
                        "month": 2,
                        "name": "MAR"
                    },
                    {
                        "month": 3,
                        "name": "APR"
                    },
                    {
                        "month": 4,
                        "name": "MAY"
                    },
                    {
                        "month": 5,
                        "name": "JUN"
                    },
                    {
                        "month": 6,
                        "name": "JUL"
                    },
                    {
                        "month": 7,
                        "name": "AUG"
                    },
                    {
                        "month": 8,
                        "name": "SEP"
                    },
                    {
                        "month": 9,
                        "name": "OCT"
                    },
                    {
                        "month": 10,
                        "name": "NOV"
                    },
                    {
                        "month": 11,
                        "name": "DEC"
                    },
                ]

                delegate: MonoText {
                    required property var model
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    font.pointSize: 14
                    text: model.name
                    color: selectMonthArea.containsMouse ? ColorService.dark3 : ColorService.dark1

                    MouseArea {
                        id: selectMonthArea
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true

                        onClicked: () => {
                            monthGrid.changeDate(new Date(root.selectedYear, parent.model.month, 1), true);
                            stack.currentIndex = 0;
                        }
                    }
                }
            }
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

    TaskList {
        Layout.row: 2
        Layout.column: 0
        Layout.columnSpan: 3
        Layout.fillWidth: true
        Layout.topMargin: 16
        height: 300
    }
}
