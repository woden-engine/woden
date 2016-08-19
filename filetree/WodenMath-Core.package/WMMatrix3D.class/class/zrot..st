special matrices
zrot: angle
	<argument: #angle type: #double>
	<returnType: #(SelfType object)>
	<var: #(one zero cos sin) type: #double>
	| one zero cos sin|
	one := 1.0 asNativeDouble.
	zero := 0.0 asNativeDouble.
	cos := angle cos asNativeDouble.
	sin := angle sin asNativeDouble.
	^ self 
		m11: cos m12: sin negated m13: zero
		m21: sin m22: cos m23: zero
		m31: zero m32: zero m33: one