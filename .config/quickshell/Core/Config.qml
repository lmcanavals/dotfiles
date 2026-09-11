pragma Singleton

import QtQuick

QtObject {
    readonly property int barHeight: 28
    readonly property int widgetHeight: 26
    readonly property int workspaceButtonWidth: 28
    readonly property int radius: 5
    readonly property int padding: 8
    readonly property int margin: 2
    readonly property int spacing: 5
    readonly property string osIcon: "󰣇"
    readonly property string dateFormat: "dddd, d MMMM yyyy"
    readonly property string timeFormat: "HH:mm"
    readonly property string fontFamily: "sans-serif, Font Awesome 7 Free, Symbols Nerd Font"
    readonly property int fontSize: 16
}
// vim: set ts=4 sw=4 et sts=0 :
