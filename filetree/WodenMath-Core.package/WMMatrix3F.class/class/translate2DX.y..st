special matrices
translate2DX: x y: y
	<argument: #(x y) type: #float>
	<returnType: #(SelfType object)>
	<var: #(zero one) type: #float>
	| zero one |
	zero := 0.0 asNativeFloat.
	one := 1.0 asNativeFloat.
	^ self 
		m11: one m12: zero negated m13: x
		m21: zero m22: one m23: y
		m31: zero m32: zero m33: one