transformations
transformVector3: vector
	<argument: #vector type: #(WMVector3D object)>
	^ WMVector3D
		x: (m11 * vector x) + (m12 * vector y) + (m13 * vector z)
		y: (m21 * vector x) + (m22 * vector y) + (m23 * vector z)
		z: (m31 * vector x) + (m32 * vector y) + (m33 * vector z)