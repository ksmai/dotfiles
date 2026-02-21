import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import Quickshell.Services.Notifications

Rectangle {
    id: root

    required property Notification notification
    property real padding: 12
    // TODO: cache lookups
    readonly property string appIcon: {
        if (!notification.appName) {
            return "";
        }
        for (const entry of DesktopEntries.applications.values) {
            if (String(entry.name) === notification.appName) {
                if (!entry.icon) {
                    return "";
                }
                return `image://icon/${entry.icon}`;
            }
        }
        return "";
    }

    implicitWidth: 400
    implicitHeight: grid.implicitHeight + padding * 2
    border.color: "#3c3836"
    border.width: 2
    color: "#fabd2f"
    radius: 8

    RectangularShadow {
        z: -1
        anchors.fill: root
        offset.x: 4
        offset.y: 4
        radius: 8
        blur: 0
        spread: 0
        color: "#3c3836"
    }

    GridLayout {
        id: grid
        columns: 2
        columnSpacing: 10
        anchors.left: parent.left
        anchors.leftMargin: root.padding
        anchors.right: parent.right
        anchors.rightMargin: root.padding
        y: root.padding

        // Image {
        //     source: root.notification.image
        //     fillMode: Image.PreserveAspectFit
        //
        //     Layout.row: 0
        //     Layout.rowSpan: 2
        //     Layout.column: 0
        //     Layout.preferredWidth: 50
        // }

        Image {
            source: root.appIcon
            fillMode: Image.PreserveAspectFit

            Layout.row: 0
            Layout.rowSpan: 2
            Layout.column: 0
            Layout.preferredWidth: 50
        }

        Text {
            text: root.notification.summary
            color: "#3c3836"
            font.family: "monospace"
            font.pointSize: 12
            font.weight: 900
            wrapMode: Text.Wrap

            Layout.row: 0
            Layout.column: 1
            Layout.fillWidth: true
        }

        Text {
            text: root.notification.body
            color: "#3c3836"
            font.family: "monospace"
            font.pointSize: 12
            font.weight: 500
            wrapMode: Text.Wrap

            Layout.row: 1
            Layout.column: 1
            Layout.fillWidth: true
        }
    }
}
