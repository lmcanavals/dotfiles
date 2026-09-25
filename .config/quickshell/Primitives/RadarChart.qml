import QtQuick
import Core

Canvas {
	id: root

	property var values: []
	property real total: 0.
	property real maxValue: 1.

	// Appearance
	property color gridColor: Theme.colors.border
	property color spokeColor: Theme.colors.border
	property color areaColor: Theme.bgControlHover
	property color lineColor: Theme.colors.success
	property real lineWidth: 1.
	property int gridLevels: 2
	property string glyph: "R"

	antialiasing: true

	onTotalChanged: requestPaint()
	onWidthChanged: requestPaint()
	onHeightChanged: requestPaint()

	onPaint: {
		const ctx = getContext("2d");
		ctx.reset();

		const count = values ? values.length : 0;
		if (count < 3)
			return;

		// 0. Draw top-left label
		ctx.fillStyle = lineColor;
		ctx.font = "12px monospace";
		ctx.textBaseline = "top";
		ctx.textAlign = "left";
		ctx.fillText(`${Math.round(Math.max(0.0, Math.min(1.0, root.total)) * 100)}%`, 16, 0);
		ctx.font = "24px monospace";
		ctx.textBaseline = "bottom";
		ctx.textAlign = "left";
		ctx.fillText(glyph, 0, height);

		const barX = 4;
		const barY = 8;
		const barW = 8;
		const barH = height - 38;

		if (barH > 0) {
			// background bar
			ctx.strokeStyle = gridColor;
			ctx.lineWidth = barW;
			ctx.lineCap = "round";
			ctx.beginPath();
			ctx.moveTo(barX + barW / 2, barY);
			ctx.lineTo(barX + barW / 2, barY + barH);
			ctx.stroke();

			// filled portion
			const clampedTotal = Math.max(0, Math.min(root.total, 1.0));
			const fillH = barH * clampedTotal;

			ctx.strokeStyle = lineColor;
			ctx.beginPath();
			ctx.moveTo(barX + barW / 2, barY + barH - fillH);
			ctx.lineTo(barX + barW / 2, barY + barH);
			ctx.stroke();
		}

		const leftOffset = 20;
		const availWidth = width - leftOffset;
		const centerX = leftOffset + (availWidth / 2);
		const centerY = height / 2;
		const radius = Math.min(availWidth / 2, centerY) - (lineWidth * 2);
		if (radius <= 0)
			return;

		const angleStep = (2 * Math.PI) / count;
		const startOffset = -Math.PI / 2; // Spoke 0 at 12 o'clock

		// 1. Draw concentric background polygon web
		ctx.strokeStyle = gridColor;
		ctx.lineWidth = 1.0;
		for (let level = 1; level <= gridLevels; ++level) {
			const levelRadius = (radius / gridLevels) * level;
			ctx.beginPath();
			for (let i = 0; i < count; ++i) {
				const angle = startOffset + i * angleStep;
				const x = centerX + levelRadius * Math.cos(angle);
				const y = centerY + levelRadius * Math.sin(angle);
				if (i === 0)
					ctx.moveTo(x, y);
				else
					ctx.lineTo(x, y);
			}
			ctx.closePath();
			ctx.stroke();
		}

		// 2. Draw radial spokes from center
		ctx.strokeStyle = spokeColor;
		for (let i = 0; i < count; ++i) {
			const angle = startOffset + i * angleStep;
			ctx.beginPath();
			ctx.moveTo(centerX, centerY);
			ctx.lineTo(centerX + radius * Math.cos(angle), centerY + radius * Math.sin(angle));
			ctx.stroke();
		}

		// 3. Draw connecting value polygon
		ctx.beginPath();
		for (let i = 0; i < count; ++i) {
			const val = Math.max(0, Math.min(values[i] / maxValue, 1.0));
			const pointRadius = radius * val;
			const angle = startOffset + i * angleStep;
			const x = centerX + pointRadius * Math.cos(angle);
			const y = centerY + pointRadius * Math.sin(angle);

			if (i === 0)
				ctx.moveTo(x, y);
			else
				ctx.lineTo(x, y);
		}
		ctx.closePath();

		// Fill area
		ctx.fillStyle = areaColor;
		ctx.fill();

		ctx.strokeStyle = lineColor;
		ctx.lineWidth = root.lineWidth;
		ctx.stroke();
	}
}
