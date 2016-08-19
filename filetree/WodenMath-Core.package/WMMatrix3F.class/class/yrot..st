special matrices
yrot: angle
	<argument: #angle type: #float>
	<returnType: #(SelfType object)>
	<var: #(one zero cos sin) type: #float>
	| one zero cos sin|
	one := 1.0 asNativeFloat.
	zero := 0.0 asNativeFloat.
	cos := angle cos asNativeFloat.
	sin := angle sin asNativeFloat.
	^ self 
		m11: cos m12: zero m13: sin
		m21: zero m22: one m23: zero
		m31: sin negated m32: zero m33: cos