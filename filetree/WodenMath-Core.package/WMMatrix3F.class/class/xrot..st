special matrices
xrot: angle
	<argument: #angle type: #float>
	<returnType: #(SelfType object)>
	<var: #(one zero cos sin) type: #float>
	| one zero cos sin|
	one := 1.0 asNativeFloat.
	zero := 0.0 asNativeFloat.
	cos := angle cos asNativeFloat.
	sin := angle sin asNativeFloat.
	^ self 
		m11: one m12: zero m13: zero
		m21: zero m22: cos m23: sin negated
		m31: zero m32: sin m33: cos