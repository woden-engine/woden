arithmetic
normalized
	<var: #il type: #float>
	| il |
	il := ((x*x) + (y*y) + (z*z)) sqrt.
	il > 0.00001 asNativeFloat ifTrue: [ il := 1.0 asNativeFloat / il ] ifFalse: [ il := 0.0 asNativeFloat ].
	^ self class x: x * il y: y * il z: z * il