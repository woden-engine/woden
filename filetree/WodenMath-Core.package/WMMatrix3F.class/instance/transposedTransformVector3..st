transformation
transposedTransformVector3: vector3
	<argument: #vector3 type: #(WMVector3F object)>
	<returnType: #(WMVector3F object)>
	^ WMVector3F
		x: (m11 * vector3 x) + (m21 * vector3 y) + (m31 * vector3 z) 
		y: (m12 * vector3 x) + (m22 * vector3 y) + (m32 * vector3 z) 
		z: (m13 * vector3 x) + (m23 * vector3 y) + (m33 * vector3 z)