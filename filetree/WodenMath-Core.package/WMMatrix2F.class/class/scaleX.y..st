special matrices
scaleX: xScale y: yScale
	<argument: #(xScale yScale) type: #float>
	<var: #zero type: #float>
	| zero |
	zero := 0.0 asNativeFloat.
	^ self 
		m11: xScale m12: zero negated
		m21: zero m22: yScale