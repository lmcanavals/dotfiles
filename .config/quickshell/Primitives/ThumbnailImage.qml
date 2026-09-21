pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Core
import Primitives

Rectangle {
	id: root

	property string source: ""
	property string fallbackIcon: "󰂚"
	property bool showFallback: true
	property real minHeight: 64
	property real maxHeight: 80
	property real minAspect: 1.0
	property real maxAspect: 2.39

	readonly property string actualSource: {
		const src = root.source ? String(root.source).trim() : "";
		if (src.length === 0)
			return "";
		if (src.startsWith("file://") || src.startsWith("http://") || src.startsWith("https://") || src.startsWith("image://"))
			return src;
		if (src.startsWith("/"))
			return "file://" + src;
		if (Quickshell.hasThemeIcon(src))
			return Quickshell.iconPath(src);
		const p = Quickshell.iconPath(src);
		return (p && p.length > 0) ? p : src;
	}

	readonly property bool hasValidImage: artImage.status === Image.Ready
	readonly property real realAspectRatio: (hasValidImage && artImage.sourceSize.height > 0) ? (artImage.sourceSize.width / artImage.sourceSize.height) : 1.0
	readonly property real clampedAspect: Math.max(root.minAspect, Math.min(root.maxAspect, root.realAspectRatio))
	readonly property real calculatedHeight: (hasValidImage && artImage.sourceSize.height > 0) ? Math.max(root.minHeight, Math.min(root.maxHeight, artImage.sourceSize.height)) : root.minHeight
	readonly property real calculatedWidth: calculatedHeight * clampedAspect

	clip: true
	radius: Config.radius
	color: Theme.colors.bg_highlight

	visible: root.showFallback || hasValidImage

	implicitWidth: hasValidImage ? calculatedWidth : root.minHeight
	implicitHeight: calculatedHeight

	Image {
		id: artImage
		anchors.fill: parent
		asynchronous: false
		fillMode: (root.realAspectRatio > root.maxAspect || root.realAspectRatio < root.minAspect) ? Image.PreserveAspectCrop : Image.PreserveAspectFit
		source: root.actualSource
		visible: status === Image.Ready
	}

	StyledText {
		anchors.centerIn: parent
		color: Theme.colors.comment
		font.pixelSize: Config.fontSizeXL
		text: root.fallbackIcon
		visible: root.showFallback && artImage.status !== Image.Ready
	}
}
