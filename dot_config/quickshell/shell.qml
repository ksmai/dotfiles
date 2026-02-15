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
            color: root.bgColor
            implicitHeight: Math.max(left.implicitHeight) + 10

            anchors {
                bottom: true
                left: true
                right: true
            }

            Row {
                id: left
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 3

                Workspaces {}
            }

            Row {
                id: right
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: 3
                spacing: 8

                Clock {}
                Tray {}
            }
        }
    }
}
