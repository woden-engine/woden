special matrices
scale: s
	<argument: #s type: #double>
	^ self new
		m11: s; m22: s; m33: s; m44: 1.0 asNativeDouble;
		yourself