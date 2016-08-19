arithmetic
normalized
	<var: #il type: #double>
	| il |
	il := ((x*x) + (y*y) + (z*z)) sqrt.
	il > 0.00001 asNativeDouble ifTrue: [ il := 1.0 asNativeDouble / il ] ifFalse: [ il := 0.0 asNativeDouble ].
	^ self class x: x * il y: y * il z: z * il