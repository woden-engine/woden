tests
testRotateByZDegrees
	| angle matrix |
	angle := 60.
	matrix :=WDMatrix3 zrot: angle degreesToRadians.
	element rotateByZDegrees: angle.
	self assert: (element orientationMatrix closeTo: matrix)