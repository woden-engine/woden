special matrices
identity
	<returnType: #(SelfType object)>
	^ self new
		m11: 1.0 asNativeDouble; m22: 1.0 asNativeDouble; m33: 1.0 asNativeDouble; m44: 1.0 asNativeDouble;
		yourself