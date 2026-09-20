pragma ComponentBehavior: Bound
import Core
import Primitives

import QtQuick
import QtQuick.Layouts
import Quickshell
import Services

PopupWindow {
	id: root

	function formatTime(val: real): string {
		if (val <= 0 || isNaN(val))
			return "0:00";
		const totalSecs = val > 10000 ? Math.floor(val / 1000000) : Math.floor(val);
		const mins = Math.floor(totalSecs / 60);
		const secs = totalSecs % 60;
		return `${mins}:${secs < 10 ? "0" : ""}${secs}`;
	}

	color: "transparent"
	grabFocus: true
	implicitHeight: contentLayout.implicitHeight + Config.padding * 4
	implicitWidth: 450
	visible: MediaService.open && MediaService.targetItem !== null

	onVisibleChanged: {
		if (!visible && MediaService.open) {
			MediaService.close();
		}
	}

	// qmllint disable missing-type
	anchor {
		edges: Edges.Bottom
		gravity: Edges.Bottom
		item: MediaService.targetItem
	}

	SurfaceCard {
		id: mainCard

		anchors.fill: parent
		border.color: Theme.colors.border
		border.width: 1
		color: Theme.alpha(Theme.colors.bg_dark, 0.4)
		radius: Config.radius * 2

		// Top Row: Album Art & Track Metadata
		RowLayout {
			id: contentLayout

			anchors.fill: parent
			anchors.margins: Config.padding * 2
			spacing: Config.spacing * 2

			Rectangle {
				id: artContainer
				clip: true
				radius: Config.radius
				color: Theme.colors.bg_highlight

				property real realAspectRatio: artImage.status === Image.Ready ? artImage.sourceSize.width / artImage.sourceSize.height : 1

				property real minAspect: 1.0
				property real maxAspect: 2.39
				property real clampedAspect: Math.max(minAspect, Math.min(maxAspect, realAspectRatio))

				property real finalHeight: Math.max(64, Math.min(100, artImage.sourceSize.height))
				property real finalWidth: finalHeight * clampedAspect

				property int finalFillMode: {
					if (realAspectRatio > maxAspect || realAspectRatio < minAspect)
						return Image.PreserveAspectCrop;
					return Image.PreserveAspectFit;
				}

				implicitWidth: artImage.status === Image.Ready ? finalWidth : 64
				implicitHeight: artImage.status === Image.Ready ? finalHeight : 64

				Image {
					id: artImage
					anchors.fill: parent
					asynchronous: false
					fillMode: artContainer.finalFillMode
					source: MediaService.artUrl
					visible: status === Image.Ready
				}

				StyledText {
					anchors.centerIn: parent
					color: Theme.colors.comment
					font.pixelSize: Config.fontSize * 3
					text: "󰎈"
					visible: artImage.status !== Image.Ready
				}
			}

			ColumnLayout {
				Layout.alignment: Qt.AlignVCenter
				Layout.fillWidth: true
				spacing: 3

				StyledText {
					Layout.fillWidth: true
					color: Theme.colors.fg
					elide: Text.ElideRight
					font.bold: true
					text: MediaService.title
				}

				RowLayout {
					Layout.fillWidth: true
					spacing: Config.spacing

					StyledText {
						Layout.fillWidth: true
						elide: Text.ElideRight
						font.pixelSize: Config.fontSize - 2
						text: MediaService.artist
					}

					StyledText {
						Layout.fillWidth: true
						elide: Text.ElideRight
						font.pixelSize: Config.fontSize - 2
						text: MediaService.album
						horizontalAlignment: Text.AlignRight
					}
				}

				// Interactive Seek Track
				ColumnLayout {
					Layout.fillWidth: true
					spacing: 4

					TrackSlider {
						Layout.fillWidth: true
						implicitHeight: 6
						value: MediaService.progress
						accentColor: Theme.colors.accent
						onValueModified: ratio => MediaService.seek(ratio)
					}

					RowLayout {
						Layout.fillWidth: true

						StyledText {
							color: Theme.colors.comment
							font.pixelSize: Config.fontSize - 4
							text: root.formatTime(MediaService.position)
						}

						Item {
							Layout.fillWidth: true
						}

						StyledText {
							color: Theme.colors.comment
							font.pixelSize: Config.fontSize - 4
							text: root.formatTime(MediaService.length)
						}
					}
				}

				// Transport Buttons (previous, play/pause, next)
				RowLayout {
					Layout.alignment: Qt.AlignHCenter
					spacing: Config.spacing * 2

					StyledButton {
						text: "󰒮"

						onClicked: MediaService.previous()
					}

					StyledButton {
						text: MediaService.isPlaying ? "󰏤" : "󰐊"

						onClicked: MediaService.playPause()
					}

					StyledButton {
						text: "󰒭"

						onClicked: MediaService.next()
					}
				}
			}
		}
	}
}
