special matrices
zrot: angle
	<argument: #angle type: #float>
	<returnType: #(SelfType object)>
	<var: #(one zero cos sin) type: #float>
	| one zero cos sin|
	one := 1.0 asNativeFloat.
	zero := 0.0 asNativeFloat.
	cos := angle cos asNativeFloat.
	sin := angle sin asNativeFloat.
	^ self 
		m11: cos m12: sin negated m13: zero
		m21: sin m22: cos m23: zero
		m31: zero m32: zero m33: one