construction
m11: m11 m12: m12
m21: m21 m22: m22
	<argument: #(m11 m12) type: #double>
	<argument: #(m21 m22) type: #double>
	<constructor>
	^ self new
		m11: m11; m12: m12;
		m21: m21; m22: m22;
		yourself