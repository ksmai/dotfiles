pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell

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

    width: 400
    implicitHeight: column.implicitHeight
    border.color: ColorService.dark1
    border.width: 2
    color: ColorService.bright_yellow
    radius: 8

    RectangularShadow {
        z: -1
        anchors.fill: root
        offset.x: 4
        offset.y: 4
        radius: 8
        blur: 0
        spread: 0
        color: ColorService.dark1
    }

    ColumnLayout {
        id: column
        anchors.left: parent.left
        anchors.right: parent.right

        MouseArea {
            Layout.fillWidth: true
            implicitHeight: grid.implicitHeight + root.padding * 2
            cursorShape: Qt.PointingHandCursor
            acceptedButtons: Qt.LeftButton | Qt.MiddleButton

            onClicked: mouse => {
                switch (mouse.button) {
                case Qt.LeftButton:
                    if (root.defaultAction) {
                        root.defaultAction.invoke();
                    } else {
                        root.notificationObject.dismiss();
                    }
                    break;
                case Qt.MiddleButton:
                    root.notificationObject.dismiss();
                    break;
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
                    sourceComponent: MonoText {
                        text: root.notificationObject.summary
                        wrapMode: Text.Wrap
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignTop
                    }
                }

                Loader {
                    Layout.row: 0
                    Layout.column: 2

                    active: !!root.notificationObject.timeString
                    sourceComponent: MonoText {
                        text: root.notificationObject.timeString
                        font.weight: 500
                        wrapMode: Text.Wrap
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignTop
                    }
                }

                PressableButton {
                    Layout.row: 0
                    Layout.column: 3

                    text: ""
                    horizontalPadding: 8
                    backgroundColor: ColorService.bright_orange
                    onLeftClicked: () => {
                        root.notificationObject.dismiss();
                    }
                }

                Loader {
                    Layout.row: 1
                    Layout.column: 1
                    Layout.columnSpan: 3
                    Layout.fillWidth: true

                    active: !!root.notificationObject.body
                    sourceComponent: MonoText {
                        text: root.notificationObject.body
                        font.weight: 500
                        wrapMode: Text.Wrap
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignTop
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
                        color: ColorService.dark1
                        height: 2
                    }

                    Rectangle {
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        anchors.right: parent.right
                        color: ColorService.dark1
                        width: actionMouseArea.index % 2 === 0 ? 2 : 0
                    }

                    MonoText {
                        id: actionText
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        text: actionMouseArea.modelData.text
                        font.weight: 500
                        font.capitalization: Font.AllUppercase
                        wrapMode: Text.Wrap
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
