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
	} // qmllint enable missing-type

	SurfaceCard {
		id: mainCard

		implicitHeight: contentLayout.implicitHeight + Config.padding * 3
		implicitWidth: 400
		color: Theme.bgSurface

		RowLayout {
			id: contentLayout

			anchors {
				left: parent.left
				right: parent.right
				top: parent.top
				margins: Config.padding * 1.5
			}

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

				StyledText {
					Layout.fillWidth: true
					font.bold: true
					text: MediaService.title
				}

				RowLayout {
					Layout.fillWidth: true
					visible: MediaService.artist || MediaService.album

					StyledText {
						color: Theme.colors.fg
						font.pixelSize: Config.fontSizeSmall
						text: MediaService.artist
					}

					Item {
						Layout.fillWidth: true
					}

					StyledText {
						color: Theme.colors.fg
						font.pixelSize: Config.fontSizeSmall
						text: MediaService.album
					}
				}

				TrackSlider {
					Layout.fillWidth: true
					implicitHeight: 6
					value: MediaService.progress
					accentColor: Theme.colors.accent
					onValueModified: ratio => MediaService.seek(ratio)
				}

				RowLayout {
					StyledButton {
						text: ""

						onClicked: MediaService.previous()
					}

					StyledButton {
						text: MediaService.isPlaying ? "" : ""

						onClicked: MediaService.playPause()
					}

					StyledButton {
						text: ""

						onClicked: MediaService.next()
					}

					Item {
						Layout.fillWidth: true
					}

					StyledText {
						text: MediaService.formatTime(MediaService.position)
						Layout.minimumWidth: 30
						color: Theme.colors.fg
						font.pixelSize: Config.fontSizeSmall
					}

					StyledText {
						text: "/"
						color: Theme.colors.fg
						font.pixelSize: Config.fontSizeSmall
					}

					StyledText {
						text: MediaService.formatTime(MediaService.length)
						Layout.minimumWidth: 30
						color: Theme.colors.fg
						font.pixelSize: Config.fontSizeSmall
					}
				}
			}
		}
	}
}
