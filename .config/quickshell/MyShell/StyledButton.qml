import QtQuick
import "."

Rectangle {
    id: btn

    property color baseColor: {
        focused ? Config.focusedBackground : Config.itemBackground;
    }
    property color currentVisualColor: baseColor
    required property bool focused
    property color hoverColor: Config.hoverBackground
    property color pressedColor: Config.pressedBackground
    property string text

    signal clicked

    color: currentVisualColor
    implicitHeight: Config.height
    implicitWidth: buttonText.paintedWidth + Config.padding * 2
    radius: Config.radius

    Behavior on color {
        ColorAnimation {
            duration: 150
        }
    }

    onFocusedChanged: {
        if (!mouseArea.containsMouse && !mouseArea.pressed) {
            if (focused) {
                currentVisualColor = Config.focusedBackground;
            } else {
                currentVisualColor = Config.itemBackground;
            }
        }
    }

    MouseArea {
        id: mouseArea

        anchors.fill: parent
        hoverEnabled: true

        onClicked: btn.clicked()
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
    }
    StyledText {
        id: buttonText

        color: btn.focused ? Config.focusedForeground : Config.foreground
        text: btn.text
    }
}

// vim: set ts=4 sw=4 et sts=0 :
