transformation
transformVector2: vector2
	<argument: #vector2 type: #(WMVector2D object)>
	<returnType: #(WMVector2D object)>
	^ WMVector2D
		x: (m11 * vector2 x) + (m12 * vector2 y)
		y: (m21 * vector2 x) + (m22 * vector2 y)