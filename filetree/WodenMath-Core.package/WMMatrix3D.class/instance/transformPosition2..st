transformation
transformPosition2: position2
	<argument: #position2 type: #(WMVector2D object)>
	<returnType: #(WMVector2D object)>
	^ WMVector2D
		x: (m11 * position2 x) + (m12 * position2 y) + m13
		y: (m21 * position2 x) + (m22 * position2 y) + m23