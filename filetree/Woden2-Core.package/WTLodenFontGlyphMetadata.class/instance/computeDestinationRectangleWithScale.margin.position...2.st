accessing
computeDestinationRectangleWithScale: scale margin: margin position: position
	<argument: #margin type: #float>
	<var: #(drawPosition drawExtent) type: #(WMVector2F object)>
	| drawPosition drawExtent |
	drawPosition := position + ((WMVector2F x: horizontalBearing x - margin y: (horizontalBearing y + margin) negated) * scale).
	drawExtent := (box max - box min + (WMVector2F x: margin* 2.0 asNativeFloat  y: margin*2.0 asNativeFloat)) * scale.
	^ WMBox2DF min: drawPosition max: (drawPosition + drawExtent) asWMVector2F