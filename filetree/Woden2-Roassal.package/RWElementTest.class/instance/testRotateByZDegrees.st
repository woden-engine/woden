tests
testRotateByZDegrees
	| angle matrix |
	angle := 60.
	matrix := WMMatrix3F zrot: angle degreesToRadians.
	element rotateByZDegrees: angle.
	self assert: (element orientationMatrix closeTo: matrix)