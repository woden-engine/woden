tests
testRotateByXDegrees
	| angle matrix |
	angle := 60.
	matrix :=WDMatrix3 xrot: angle degreesToRadians.
	element rotateByXDegrees: angle.
	self assert: (element orientationMatrix closeTo: matrix)