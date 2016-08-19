transformation
transformPosition2: position2
	<argument: #position2 type: #(WMVector2F object)>
	<returnType: #(WMVector2F object)>
	^ WMVector2F
		x: (m11 * position2 x) + (m12 * position2 y) + m13
		y: (m21 * position2 x) + (m22 * position2 y) + m23