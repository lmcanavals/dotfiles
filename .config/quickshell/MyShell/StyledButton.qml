import QtQuick
import "."

SimpleWidget {
    id: btn

    property color baseColor: focused ? Config.focusedBackground : Config.itemBackground
    property color currentVisualColor: baseColor
    property color hoverColor: "#2ecc71"
    property color pressedColor: "orange"
    property string text

    required property bool focused

    signal clicked

    color: currentVisualColor
    implicitHeight: Config.height
    textContent: buttonText

    onFocusedChanged: {
        if (!mouseArea.containsMouse && !mouseArea.pressed) {
            currentVisualColor = focused ? Config.focusedBackground : Config.itemBackground;
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true

        onEntered: {
            btn.currentVisualColor = btn.hoverColor;
        }
        onExited: {
            if (!mouseArea.pressed) {
                btn.currentVisualColor = btn.baseColor;
            }
        }

        onPressed: {
            btn.currentVisualColor = btn.pressedColor;
        }
        onReleased: {
            if (mouseArea.containsMouse) {
                btn.currentVisualColor = btn.hoverColor;
            } else {
                btn.currentVisualColor = btn.baseColor;
            }
        }

        onClicked: btn.clicked()
    }

    StyledText {
        id: buttonText

        color: btn.focused ? Config.focusedForeground : Config.foreground
        text: btn.text
    }

    Behavior on color {
        ColorAnimation {
            duration: 150
        }
    }
}
