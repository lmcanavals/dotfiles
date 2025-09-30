import ".."
import "../Popups"
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.UPower
import Quickshell

SimpleWidget {
    id: batteryWidget

    required property PanelWindow bar

    implicitWidth: trayLayout.implicitWidth + Config.padding

    BatteryPopup {
        id: batteryPopup

        anchorWindow: batteryWidget.bar
    }
    RowLayout {
        id: trayLayout

        anchors.centerIn: parent

        ListModel {
            id: combinedModel

        }
        Repeater {
            model: {
                combinedModel.clear();
                const originalDevices = UPower.devices.values.filter(d => d.isPresent);

                for (const device of originalDevices) {
                    combinedModel.append({
                        device: device,
                        popup: batteryPopup
                    });
                }
                return combinedModel;
            }

            //model: UPower.devices.values.filter(d => d.isPresent)

            delegate: MouseArea {
                id: area

                required property var modelData
                property UPowerDevice mdevice: modelData.device
                property BatteryPopup mpopup: modelData.popup

                acceptedButtons: Qt.LeftButton | Qt.RightButton
                hoverEnabled: true
                implicitHeight: Config.height
                implicitWidth: text.paintedWidth + Config.padding

                onClicked: event => {
                    if (event.button === Qt.LeftButton) {
                        console.log(`>>>> ${event.button}`);
                    }
                }
                onEntered: {
                    mpopup.currentDevice = mdevice;
                    mpopup.visible = true;
                }
                onExited: {
                    mpopup.visible = false;
                }

                StyledText {
                    id: text

                    color: {
                        if (area.mdevice.percentage < .2) {
                            return "orangered";
                        } else if (area.mdevice.percentage < .5) {
                            return "orange";
                        } else if (area.mdevice.state == 4) {
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
                        let prcnt = area.mdevice?.percentage ?? 0;
                        prcnt = prcnt == 1 ? .99 : prcnt;
                        const idx = parseInt(Math.floor(prcnt * icons.length));
                        let info = `${icons[idx]}`;
                        switch (area.mdevice.state) {
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
                                info += `!󰚥 ${prcnt * 100}%`;
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
                            const state = area.mdevice.state;
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
