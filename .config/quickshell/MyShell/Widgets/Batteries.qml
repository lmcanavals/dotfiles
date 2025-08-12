import ".."
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Services.UPower

SimpleWidget {
    implicitWidth: trayLayout.implicitWidth + Config.padding

    RowLayout {
        id: trayLayout

        anchors.centerIn: parent

        Repeater {
            model: UPower.devices.values.filter(d => d.isPresent)

            delegate: MouseArea {
                id: area

                required property UPowerDevice modelData

                acceptedButtons: Qt.LeftButton | Qt.RightButton
                hoverEnabled: true
                implicitHeight: Config.height
                implicitWidth: text.paintedWidth + Config.padding

                onClicked: event => {
                    if (event.button === Qt.LeftButton) {
                        console.log(">>>> left");
                    } else {
                        console.log(`>>>> ${event.button}`);
                    }
                }

                StyledText {
                    id: text

                    ToolTip.text: area.modelData.nativePath // TODO: more info

                    ToolTip.visible: area.containsMouse
                    color: {
                        if (area.modelData.percentage < .2) {
                            return "orangered";
                        } else if (area.modelData.percentage < .5) {
                            return "orange";
                        } else if (area.modelData.state == 4) {
                            return "lightgreen";
                        }
                        return Config.foreground;
                    }
                    text: {
                        //console.log(`>>>>>>${UPowerDeviceType.toString(area.modelData.type)}`);
                        //for (let i = 0; i < 35; ++i) {
                        //    const type = UPowerDeviceType.toString(i);
                        //    console.log(`${i} ${type}`);
                        //}
                        // TODO: handle batteries of other devices nicely
                        const icons = "󰂎 󰁺 󰁻 󰁼 󰁽 󰁾 󰁿 󰂀 󰂁 󰂂 󰁹".split(" ");
                        let prcnt = area.modelData.percentage;
                        prcnt = prcnt == 1 ? .99 : prcnt;
                        const idx = parseInt(Math.floor(prcnt * icons.length));
                        let info = `${icons[idx]}`;
                        switch (area.modelData.state) {
                        case 0:
                            // Unkwnown
                            info = "󰂑";
                            break;
                        case 1:
                            // Charging
                            info += "󱐋";
                            break;
                        case 2:
                            // Discharging
                            if (prcnt < .2) {
                                info += "!󰚥";
                            }
                            break;
                        case 4:
                            // Fully Charged
                            info += "󱐥";
                            break;
                        case 3: // Empty
                        case 5: // Pending Charge
                        case 6: // Pending Discharge
                        default:
                            // Invalid Status
                            const state = area.modelData.state;
                            const msg = UPowerDeviceState.toString(state);
                            console.log(msg);
                        }
                        return info;
                    }
                }
            }
        }
    }
}
// vim: set ts=4 sw=4 et sts=0 :
