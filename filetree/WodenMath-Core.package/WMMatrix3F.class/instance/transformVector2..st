transformation
transformVector2: vector2
	<argument: #vector2 type: #(WMVector2F object)>
	<returnType: #(WMVector2F object)>
	^ WMVector2F
		x: (m11 * vector2 x) + (m12 * vector2 y)
		y: (m21 * vector2 x) + (m22 * vector2 y)