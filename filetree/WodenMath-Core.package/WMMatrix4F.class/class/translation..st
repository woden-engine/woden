special matrices
translation: vector
	<argument: #vector type: #(WMVector3F object)>
	^ self new
		m11: 1.0 asNativeFloat; m22: 1.0 asNativeFloat; m33: 1.0 asNativeFloat; m44: 1.0 asNativeFloat;
		m14: vector x; m24: vector y; m34: vector z;
		yourself