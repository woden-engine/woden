special matrices
mat3: mat3
	<argument: #mat3 type: #(WMMatrix3F object)>
	^ self new
		m11: mat3 m11; m12: mat3 m12; m13: mat3 m13;
		m21: mat3 m21; m22: mat3 m22; m23: mat3 m23;
		m31: mat3 m31; m32: mat3 m32; m33: mat3 m33;
		m44: 1.0 asNativeFloat