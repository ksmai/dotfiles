//@ pragma UseQApplication
pragma ComponentBehavior: Bound
import Quickshell
import QtQuick

Scope {
    id: root
    property color fgColor: "#3c3836"
    property color bgColor: "#ebdbb2"
    property color brightYellow: "#fabd2f"
    property color brightOrange: "#fe8019"
    property color brightRed: "#fb4934"

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: bar
            required property ShellScreen modelData
            screen: modelData
            color: "transparent"
            implicitHeight: Math.max(left.implicitHeight, right.implicitHeight) + 14

            anchors {
                bottom: true
                left: true
                right: true
            }

            Rectangle {
                anchors.fill: parent
                color: root.bgColor

                Item {
                    anchors.fill: parent

                    Rectangle {
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.right: parent.right
                        height: 4
                        color: root.fgColor
                    }

                    Row {
                        id: left
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.verticalCenterOffset: 2
                        anchors.left: parent.left
                        anchors.leftMargin: 3

                        Workspaces {
                            screen: bar.screen
                        }
                    }

                    Row {
                        id: right
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.verticalCenterOffset: 2
                        anchors.right: parent.right
                        anchors.rightMargin: 6
                        spacing: 8

                        Clock {}
                        AudioSink {}
                        Tray {}
                    }
                }
            }
        }
    }
}
