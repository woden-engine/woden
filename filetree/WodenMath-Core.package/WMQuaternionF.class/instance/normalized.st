arithmetic
normalized
	<var: #il type: #float>
	| il |
	il := ((r*r) + (i*i) + (j*j) + (k*k)) sqrt.
	il > 0.00001 asNativeFloat ifTrue: [ il := 1.0 asNativeFloat / il ] ifFalse: [ il := 0.0 asNativeFloat ].
	^ self class r: r * il i: i * il j: j * il k: k * il