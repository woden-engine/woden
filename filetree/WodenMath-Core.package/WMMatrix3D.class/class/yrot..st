special matrices
yrot: angle
	<argument: #angle type: #double>
	<returnType: #(SelfType object)>
	<var: #(one zero cos sin) type: #double>
	| one zero cos sin|
	one := 1.0 asNativeDouble.
	zero := 0.0 asNativeDouble.
	cos := angle cos asNativeDouble.
	sin := angle sin asNativeDouble.
	^ self 
		m11: cos m12: zero m13: sin
		m21: zero m22: one m23: zero
		m31: sin negated m32: zero m33: cos