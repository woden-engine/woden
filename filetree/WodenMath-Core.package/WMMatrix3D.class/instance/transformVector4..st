transformation
transformVector4: vector4
	<argument: #vector4 type: #(WMVector4D object)>
	<returnType: #(WMVector4D object)>
	^ WMVector4D
		x: (m11 * vector4 x) + (m12 * vector4 y) + (m13 * vector4 z) 
		y: (m21 * vector4 x) + (m22 * vector4 y) + (m23 * vector4 z) 
		z: (m31 * vector4 x) + (m32 * vector4 y) + (m33 * vector4 z)
		w: vector4 w