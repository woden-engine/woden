special matrices
translation: vector
	<argument: #vector type: #(WMVector3D object)>
	^ self new
		m11: 1.0 asNativeDouble; m22: 1.0 asNativeDouble; m33: 1.0 asNativeDouble; m44: 1.0 asNativeDouble;
		m14: vector x; m24: vector y; m34: vector z;
		yourself