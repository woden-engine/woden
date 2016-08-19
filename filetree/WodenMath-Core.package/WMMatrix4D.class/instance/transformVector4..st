transformations
transformVector4: vector
	<argument: #vector type: #(WMVector4D object)>
	^ WMVector4D
		x: (m11 * vector x) + (m12 * vector y) + (m13 * vector z) + (m14 * vector w)
		y: (m21 * vector x) + (m22 * vector y) + (m23 * vector z) + (m24 * vector w)
		z: (m31 * vector x) + (m32 * vector y) + (m33 * vector z) + (m34 * vector w)
		w: (m41 * vector x) + (m42 * vector y) + (m43 * vector z) + (m44 * vector w)