linear algebra
solveSystemAtPoint: point
	| qr q r |
	qr := self qrDecomposition.
	q := qr first.
	r := qr second.
	^ r upperTriangularSolveSystemAt: (q transposedTransformVector3: point)