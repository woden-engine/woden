special matrices
rot: angle
	<argument: #angle type: #float>
	<returnType: #(SelfType object)>
	<var: #(one zero cos sin) type: #float>
	| one zero cos sin|
	one := 1.0 asNativeFloat.
	zero := 0.0 asNativeFloat.
	cos := angle cos asNativeFloat.
	sin := angle sin asNativeFloat.
	^ self new
		m11: cos m12: sin negated
		m21: sin negated m22: cos