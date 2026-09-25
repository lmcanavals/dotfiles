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
		if (src.startsWith("image://icon//"))
			return "file://" + src.substring(13);
		if (src.startsWith("image://icon/file://"))
			return src.substring(13);
		if (src.startsWith("file://") || src.startsWith("http://") || src.startsWith("https://") || src.startsWith("image://"))
			return src;
		if (src.startsWith("/"))
			return "file://" + src;

		const iconPath = Quickshell.hasThemeIcon(src) ? Quickshell.iconPath(src) : (Quickshell.iconPath(src) || "");
		if (iconPath && iconPath.length > 0) {
			if (iconPath.startsWith("/"))
				return "file://" + iconPath;
			return iconPath;
		}
		return src;
	}

	readonly property bool hasValidImage: artImage.status === Image.Ready
	readonly property real realAspectRatio: (hasValidImage && artImage.implicitHeight > 0) ? (artImage.implicitWidth / artImage.implicitHeight) : 1.0
	readonly property real clampedAspect: Math.max(root.minAspect, Math.min(root.maxAspect, root.realAspectRatio))
	readonly property real calculatedHeight: hasValidImage ? Math.max(root.minHeight, Math.min(root.maxHeight, artImage.sourceSize.height > 0 ? (artImage.sourceSize.height / 2) : root.minHeight)) : (root.showFallback ? root.minHeight : 0)
	readonly property real calculatedWidth: calculatedHeight * clampedAspect

	clip: true
	radius: Config.radius
	color: "transparent"

	visible: hasValidImage || (root.showFallback && artImage.status !== Image.Error)

	implicitWidth: hasValidImage ? calculatedWidth : (root.showFallback ? root.minHeight : 0)
	implicitHeight: calculatedHeight

	Image {
		id: artImage
		anchors.fill: parent
		asynchronous: true
		fillMode: Image.PreserveAspectCrop
		source: root.actualSource
		visible: status === Image.Ready

		onStatusChanged: {
			if (status === Image.Error && retryTimer.retries < 3 && root.actualSource.startsWith("file://")) {
				retryTimer.retries++;
				retryTimer.start();
			}
		}
	}

	Timer {
		id: retryTimer
		interval: 100
		repeat: false
		property int retries: 0
		onTriggered: {
			const s = artImage.source;
			artImage.source = "";
			artImage.source = s;
		}
	}

	onActualSourceChanged: {
		retryTimer.retries = 0;
		retryTimer.stop();
	}

	StyledText {
		anchors.centerIn: parent
		color: Theme.colors.comment
		font.pixelSize: Config.fontSizeXL
		text: root.fallbackIcon
		visible: root.showFallback && artImage.status !== Image.Ready
	}
}
