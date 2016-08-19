special matrices
scaleX: xScale y: yScale
	<argument: #(xScale yScale) type: #double>
	<var: #zero type: #double>
	| zero |
	zero := 0.0 asNativeDouble.
	^ self 
		m11: xScale m12: zero negated
		m21: zero m22: yScale