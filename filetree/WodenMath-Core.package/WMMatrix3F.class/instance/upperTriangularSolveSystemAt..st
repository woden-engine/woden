linear algebra
upperTriangularSolveSystemAt: point
	<argument: #(point) type: #(WMVector3F object)>
	<var: #(x y z) type: #float>
	| z y x |
	((m33 closeTo: 0.0) or: [ (m22 closeTo: 0.0) or: [m11 closeTo: 0.0]]) ifTrue: [ ^ nil ].
	z := point z / m33.
	y := (point y - (z * m23))  / m22.
	x := (point x - (y * m12) - (z * m13)) / m11.
	^ WMVector3F x: x y: y z: z