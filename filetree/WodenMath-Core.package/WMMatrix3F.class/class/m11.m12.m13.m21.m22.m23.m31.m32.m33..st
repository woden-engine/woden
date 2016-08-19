construction
m11: m11 m12: m12 m13: m13
m21: m21 m22: m22 m23: m23
m31: m31 m32: m32 m33: m33
	<argument: #(m11 m12 m13) type: #float>
	<argument: #(m21 m22 m23) type: #float>
	<argument: #(m31 m32 m33) type: #float>
	<constructor>
	^ self new
		m11: m11; m12: m12; m13: m13;
		m21: m21; m22: m22; m23: m23;
		m31: m31; m32: m32; m33: m33;
		yourself