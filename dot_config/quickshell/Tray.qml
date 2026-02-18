pragma ComponentBehavior: Bound
import Quickshell.Services.SystemTray
import QtQuick
import Quickshell

PressableButton {
    backgroundColor: "#b8bb26"
    horizontalPadding: 8

    Row {
        spacing: 4

        Repeater {
            model: SystemTray.items

            MouseArea {
                id: item
                required property SystemTrayItem modelData
                implicitWidth: img.implicitWidth
                implicitHeight: img.implicitHeight
                acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton

                onClicked: mouse => {
                    switch (mouse.button) {
                    case Qt.LeftButton:
                        modelData.activate();
                        mouse.accepted = true;
                        break;
                    case Qt.MiddleButton:
                        modelData.secondaryActivate();
                        mouse.accepted = true;
                        break;
                    case Qt.RightButton:
                        if (modelData.hasMenu) {
                            menu.anchorX = mouse.x;
                            menu.anchorY = mouse.y;
                            menu.active = true;
                        }
                        mouse.accepted = true;
                        break;
                    }
                }

                Image {
                    id: img
                    source: item.modelData.icon
                    height: 22
                    fillMode: Image.PreserveAspectFit
                }

                Loader {
                    id: menu
                    property real anchorX
                    property real anchorY
                    active: false
                    sourceComponent: QsMenuAnchor {
                        anchor.item: item
                        menu: item.modelData.menu
                        Component.onCompleted: {
                            this.anchor.rect.x = menu.anchorX;
                            this.anchor.rect.y = menu.anchorY;
                            this.anchor.gravity = Edges.Top | Edges.Left;
                            this.open();
                        }
                        onClosed: {
                            menu.active = false;
                        }
                    }
                }

                QsMenuOpener {
                    menu: item.modelData.menu
                    Component.onCompleted: {
                        // console.log(this.children);
                        // console.log(this.children.size);

                        for (let x of this.children.values) {
                            // console.log(x.hasChildren);
                        }
                    }
                }
            }
        }
    }
}
