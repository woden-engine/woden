special matrices
identity
	<returnType: #(SelfType object)>
	^ self new
		m11: 1.0 asNativeFloat; m22: 1.0 asNativeFloat; m33: 1.0 asNativeFloat; m44: 1.0 asNativeFloat;
		yourself