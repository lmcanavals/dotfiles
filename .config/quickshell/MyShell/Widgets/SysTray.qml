import ".."
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray

SimpleWidget {
    implicitWidth: trayLayout.implicitWidth + Config.padding * 2

    RowLayout {
        id: trayLayout

        anchors.centerIn: parent

        Repeater {
            model: SystemTray.items

            delegate: MouseArea {
                id: area

                required property SystemTrayItem modelData

                acceptedButtons: Qt.LeftButton | Qt.RightButton
                implicitWidth: Config.height - 4
                implicitHeight: Config.height - 4

                onClicked: event => {
                    if (event.button === Qt.LeftButton) {
                        modelData.activate();
                    } else if (modelData.hasMenu) {
                        const p = area.mapToItem(null, area.x, area.y);
                        area.modelData.display(this.QsWindow.window,
                                               p.x, p.y + Config.height);
                    }
                }

                IconImage {
                    id: icon

                    source: {
                        let icon = area.modelData.icon;
                        if (icon.includes("?path=")) {
                            const [n, path] = icon.split("?path=");
                            const name = n.slice(n.lastIndexOf("/") + 1);
                            icon = `file://${path}/${name}`;
                        }
                        return icon;
                    }
                    asynchronous: true
                    anchors.fill: parent
                }
            }
        }
    }
}
// vim: set ts=4 sw=4 et sts=0 :
