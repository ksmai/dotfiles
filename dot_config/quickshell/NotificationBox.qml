pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import Quickshell.Services.Notifications

Rectangle {
    id: root

    required property NotificationObject notificationObject
    property real padding: 16
    property real iconSize: 50
    property real appIconSize: 20

    readonly property string appIcon: {
        if (notificationObject.appIcon) {
            return notificationObject.appIcon;
        }
        if (!notificationObject.appName) {
            return null;
        }
        const entry = DesktopEntries.heuristicLookup(notificationObject.appName);
        if (!entry || !entry.icon) {
            return null;
        }
        return `image://icon/${entry.icon}`;
    }

    readonly property list<var> nonDefaultActions: notificationObject.actions.filter(action => action.text !== "default") ?? []
    readonly property var defaultAction: notificationObject.actions.filter(action => action.text === "default")[0]

    implicitWidth: 400
    height: column.implicitHeight
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

    ColumnLayout {
        id: column
        anchors.left: parent.left
        anchors.right: parent.right

        MouseArea {
            Layout.fillWidth: true
            implicitHeight: grid.implicitHeight + root.padding * 2
            cursorShape: Qt.PointingHandCursor
            acceptedButtons: Qt.LeftButton

            onClicked: () => {
                if (root.defaultAction) {
                    root.defaultAction.invoke();
                } else {
                    root.notificationObject.dismiss();
                }
            }

            GridLayout {
                id: grid
                columns: 4
                columnSpacing: 10
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: root.padding
                anchors.rightMargin: root.padding
                y: root.padding

                Loader {
                    Layout.row: 0
                    Layout.rowSpan: 2
                    Layout.column: 0
                    Layout.preferredWidth: active ? root.iconSize : 0
                    Layout.preferredHeight: active ? root.iconSize : 0

                    active: root.notificationObject.image || root.appIcon
                    sourceComponent: Item {
                        implicitWidth: mainIcon.implicitWidth
                        implicitHeight: mainIcon.implicitHeight

                        Image {
                            id: mainIcon
                            source: root.notificationObject.image || root.appIcon
                            fillMode: Image.PreserveAspectFit
                            width: root.iconSize
                            height: root.iconSize
                            x: 0
                            y: 0
                        }

                        Image {
                            source: root.notificationObject.image && root.appIcon
                            fillMode: Image.PreserveAspectFit
                            width: root.appIconSize
                            height: root.appIconSize
                            x: root.iconSize - root.appIconSize
                            y: root.iconSize - root.appIconSize
                        }
                    }
                }

                Loader {
                    Layout.row: 0
                    Layout.column: 1
                    Layout.fillWidth: true

                    active: !!root.notificationObject.summary
                    sourceComponent: Text {
                        text: root.notificationObject.summary
                        color: "#3c3836"
                        font.family: "monospace"
                        font.pointSize: 12
                        font.weight: 700
                        wrapMode: Text.Wrap
                    }
                }

                Loader {
                    Layout.row: 0
                    Layout.column: 2

                    active: !!root.notificationObject.timeString
                    sourceComponent: Text {
                        text: root.notificationObject.timeString
                        color: "#3c3836"
                        font.family: "monospace"
                        font.pointSize: 12
                        font.weight: 500
                        wrapMode: Text.Wrap
                    }
                }

                PressableButton {
                    Layout.row: 0
                    Layout.column: 3

                    text: ""
                    horizontalPadding: 8
                    backgroundColor: "#fe8019"
                    onClicked: () => {
                        root.notificationObject.dismiss();
                    }
                }

                Loader {
                    Layout.row: 1
                    Layout.column: 1
                    Layout.columnSpan: 3
                    Layout.fillWidth: true

                    active: !!root.notificationObject.body
                    sourceComponent: Text {
                        text: root.notificationObject.body
                        color: "#3c3836"
                        font.family: "monospace"
                        font.pointSize: 12
                        font.weight: 500
                        wrapMode: Text.Wrap
                    }
                }
            }
        }

        GridLayout {
            Layout.fillWidth: true
            columns: 2
            columnSpacing: 0
            rowSpacing: 0

            Repeater {
                model: ScriptModel {
                    values: root.nonDefaultActions
                }

                MouseArea {
                    id: actionMouseArea

                    required property var modelData
                    required property int index

                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.preferredWidth: 0
                    Layout.preferredHeight: actionText.implicitHeight
                    Layout.columnSpan: index % 2 === 0 && index === root.nonDefaultActions.length - 1 ? 2 : 1

                    cursorShape: Qt.PointingHandCursor

                    onClicked: () => {
                        modelData.invoke();
                    }

                    Rectangle {
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.right: parent.right
                        color: "#3c3836"
                        height: 2
                    }

                    Rectangle {
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        anchors.right: parent.right
                        color: "#3c3836"
                        width: actionMouseArea.index % 2 === 0 ? 2 : 0
                    }

                    Text {
                        id: actionText
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        text: actionMouseArea.modelData.text
                        color: "#3c3836"
                        font.family: "monospace"
                        font.pointSize: 12
                        font.weight: 500
                        font.capitalization: Font.AllUppercase
                        wrapMode: Text.Wrap
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        leftPadding: root.padding
                        rightPadding: root.padding
                        topPadding: root.padding / 2
                        bottomPadding: root.padding / 2
                    }
                }
            }
        }
    }
}
