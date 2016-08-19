special matrices
xrot: angle
	<argument: #angle type: #double>
	<returnType: #(SelfType object)>
	<var: #(one zero cos sin) type: #double>
	| one zero cos sin|
	one := 1.0 asNativeDouble.
	zero := 0.0 asNativeDouble.
	cos := angle cos asNativeDouble.
	sin := angle sin asNativeDouble.
	^ self 
		m11: one m12: zero m13: zero
		m21: zero m22: cos m23: sin negated
		m31: zero m32: sin m33: cos