//@ pragma IconTheme default
pragma ComponentBehavior: Bound
import Quickshell
import QtQuick

ShellRoot {
    id: root
    property color fgColor: "#3c3836"
    property color bgColor: "#ebdbb2"

    Variants {
        model: Quickshell.screens

        Scope {
            id: scope
            required property ShellScreen modelData

            PanelWindow {
                id: bar
                readonly property int topBorder: 4
                readonly property int padding: 5

                screen: scope.modelData
                color: root.bgColor
                implicitHeight: Math.max(left.implicitHeight, right.implicitHeight) + bar.topBorder + 2 * bar.padding

                anchors {
                    bottom: true
                    left: true
                    right: true
                }

                Rectangle {
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: bar.topBorder
                    color: root.fgColor
                }

                Row {
                    id: left
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.verticalCenterOffset: bar.topBorder / 2
                    anchors.left: parent.left
                    anchors.leftMargin: 3

                    Workspaces {
                        screen: bar.screen
                    }
                }

                Row {
                    id: right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.verticalCenterOffset: bar.topBorder / 2
                    anchors.right: parent.right
                    anchors.rightMargin: 6
                    spacing: 8

                    Privacy {}
                    Clock {}
                    AudioSink {}
                    Tray {}
                    NotificationIndicator {}
                }
            }

            PanelWindow {
                id: notifications
                screen: scope.modelData
                color: "transparent"
                exclusionMode: ExclusionMode.Normal

                anchors {
                    top: true
                    bottom: true
                    right: true
                    left: true
                }

                mask: Region {
                    item: notificationArea
                }

                NotificationArea {
                    id: notificationArea
                    screen: scope.modelData
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 16
                    anchors.right: parent.right
                    anchors.rightMargin: 16
                }
            }
        }
    }
}
