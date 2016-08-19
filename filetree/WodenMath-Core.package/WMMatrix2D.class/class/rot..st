special matrices
rot: angle
	<argument: #angle type: #double>
	<returnType: #(SelfType object)>
	<var: #(one zero cos sin) type: #double>
	| one zero cos sin|
	one := 1.0 asNativeDouble.
	zero := 0.0 asNativeDouble.
	cos := angle cos asNativeDouble.
	sin := angle sin asNativeDouble.
	^ self new
		m11: cos m12: sin negated
		m21: sin negated m22: cos