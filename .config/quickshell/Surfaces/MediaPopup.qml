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

			ThumbnailImage {
				id: artContainer
				source: MediaService.artUrl
				fallbackIcon: "󰎈"
				minHeight: 64
				maxHeight: 100
				showFallback: true
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
					font.pixelSize: Config.fontSizeLarge
					text: MediaService.title
				}

				RowLayout {
					Layout.fillWidth: true
					spacing: Config.spacing

					StyledText {
						Layout.fillWidth: true
						elide: Text.ElideRight
						font.pixelSize: Config.fontSizeSmall
						text: MediaService.artist
					}

					StyledText {
						Layout.fillWidth: true
						elide: Text.ElideRight
						font.pixelSize: Config.fontSizeSmall
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
							font.pixelSize: Config.fontSizeTiny
							text: root.formatTime(MediaService.position)
						}

						Item {
							Layout.fillWidth: true
						}

						StyledText {
							color: Theme.colors.comment
							font.pixelSize: Config.fontSizeTiny
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
