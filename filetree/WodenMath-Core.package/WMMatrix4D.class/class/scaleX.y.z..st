special matrices
scaleX: sx y: sy z: sz
	<argument: #(sx sy sz) type: #double>
	^ self new
		m11: sx; m22: sy; m33: sz; m44: 1.0 asNativeDouble;
		yourself