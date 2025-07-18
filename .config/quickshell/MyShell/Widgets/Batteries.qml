import ".."
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.UPower

SimpleWidget {
    implicitWidth: trayLayout.implicitWidth + Config.padding

    RowLayout {
        id: trayLayout

        anchors.centerIn: parent

        Repeater {
            model: UPower.devices

            delegate: MouseArea {
                id: area

                required property UPowerDevice modelData

                acceptedButtons: Qt.LeftButton | Qt.RightButton
                implicitHeight: Config.height
                implicitWidth: text.paintedWidth + Config.padding
                visible: modelData.isPresent

                onClicked: event => {
                    if (event.button === Qt.LeftButton) {
                        console.log(">>>> left");
                    } else {
                        console.log(`>>>> ${event.button}`);
                    }
                }

                StyledText {
                    id: text

                    color: {
                        if (area.modelData.percentage < .2) {
                            return "orangered";
                        } else if (area.modelData.percentage < .5) {
                            return "orange";
                        } else if (area.modelData.state == 4) {
                            return "lightgreen"
                        }
                        return Config.foreground;
                    }
                    text: {
                        //console.log(`>>>>>>${UPowerDeviceType.toString(area.modelData.type)}`);
                        if (!area.modelData.isPresent) {
                            return "";
                        }
                        //for (let i = 0; i < 35; ++i) {
                        //    console.log(`${i} ${UPowerDeviceType.toString(i)}`);
                        //}
                        // TODO: handle batteries of other devices nicely
                        const glyphs = ["󰂎", "󰁺", "󰁻", "󰁼", "󰁽", "󰁾", "󰁿", "󰂀", "󰂁", "󰂂", "󰁹"];
                        let percent = area.modelData.percentage;
                        percent = percent == 1 ? .99 : percent;
                        const idx = parseInt(Math.floor(percent * glyphs.length));
                        let info = `${glyphs[idx]}`;
                        switch (area.modelData.state) {
                        case 0:
                            // Unkwnown
                            info += "󱃞";
                            break;
                        case 1:
                            // Charging
                            info += "󱐋";
                            break;
                        case 2:
                            // Discharging
                            if (percent < .2) {
                                info += "!󰚥";
                            }
                            break;
                        case 4:
                            // Fully Charged
                            info += "󰱱";
                            break;
                        case 3: // Empty
                        case 5: // Pending Charge
                        case 6: // Pending Discharge
                        default:
                            // Invalid Status
                            console.log(UPowerDeviceState.toString(area.modelData.state));
                        }
                        return info;
                    }
                }
            }
        }
    }
}
// vim: set ts=4 sw=4 et sts=0 :
