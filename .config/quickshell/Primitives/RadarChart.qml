import QtQuick
import Core

Canvas {
	id: root

	property var values: []
	property real maxValue: 1.

	property color gridColor: Theme.colors.border
	property color spokeColor: Theme.colors.border
	property color lineColor: Theme.colors.success
	property color areaColor: Theme.alpha(lineColor, .35)
	property real lineWidth: 1.
	property int gridLevels: 3

	antialiasing: true

	onValuesChanged: requestPaint()
	onWidthChanged: requestPaint()
	onHeightChanged: requestPaint()

	onPaint: {
		const ctx = getContext("2d");
		ctx.reset();

		const count = values ? values.length : 0;
		if (count < 3)
			return;

		const centerX = width / 2;
		const centerY = height / 2;
		const radius = Math.min(centerX, centerY) - (lineWidth * 2);
		if (radius <= 0)
			return;

		const angleStep = (2 * Math.PI) / count;
		const startOffset = -Math.PI / 2; // Spoke 0 at 12 o'clock

		// 1. Draw concentric background polygon web
		ctx.strokeStyle = gridColor;
		ctx.lineWidth = 1.0;
		for (let level = 1; level <= gridLevels; ++level) {
			const levelRadius = radius * Math.sqrt(level / gridLevels);
			ctx.beginPath();
			ctx.ellipse(centerX - levelRadius, centerY - levelRadius, levelRadius * 2, levelRadius * 2, 0, 0, 2 * Math.PI);
			ctx.stroke();
		}

		// 2. Draw radial spokes from center
		ctx.strokeStyle = spokeColor;
		ctx.lineWidth = lineWidth;
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
