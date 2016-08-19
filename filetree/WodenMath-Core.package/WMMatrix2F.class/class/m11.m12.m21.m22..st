construction
m11: m11 m12: m12
m21: m21 m22: m22
	<argument: #(m11 m12) type: #float>
	<argument: #(m21 m22) type: #float>
	<constructor>
	^ self new
		m11: m11; m12: m12;
		m21: m21; m22: m22;
		yourself