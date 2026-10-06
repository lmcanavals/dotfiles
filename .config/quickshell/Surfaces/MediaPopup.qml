pragma ComponentBehavior: Bound
import Core
import Primitives

import QtQuick
import QtQuick.Layouts
import Quickshell
import Services

PopupWindow {
	id: root

	color: "transparent"
	grabFocus: true
	implicitWidth: mainCard.implicitWidth
	implicitHeight: mainCard.implicitHeight
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

		implicitHeight: contentLayout.implicitHeight + Config.padding * 3
		implicitWidth: 450
		color: Theme.bgSurface

		// Top Row: Album Art & Track Metadata
		RowLayout {
			id: contentLayout

			anchors {
				left: parent.left
				right: parent.right
				top: parent.top
				margins: Config.padding * 1.5
			}

			spacing: Config.spacing

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
					font.bold: true
					font.pixelSize: Config.fontSizeLarge
					text: MediaService.title
				}

				RowLayout {
					Layout.fillWidth: true
					spacing: Config.spacing

					StyledText {
						Layout.fillWidth: true
						font.pixelSize: Config.fontSizeSmall
						text: MediaService.artist
					}

					StyledText {
						Layout.fillWidth: true
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
							text: MediaService.formatTime(MediaService.position)
						}

						Item {
							Layout.fillWidth: true
						}

						StyledText {
							color: Theme.colors.comment
							font.pixelSize: Config.fontSizeTiny
							text: MediaService.formatTime(MediaService.length)
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
