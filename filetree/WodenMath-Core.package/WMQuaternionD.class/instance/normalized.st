arithmetic
normalized
	<var: #il type: #double>
	| il |
	il := ((r*r) + (i*i) + (j*j) + (k*k)) sqrt.
	il > 0.00001 asNativeDouble ifTrue: [ il := 1.0 asNativeDouble / il ] ifFalse: [ il := 0.0 asNativeDouble ].
	^ self class r: r * il i: i * il j: j * il k: k * il