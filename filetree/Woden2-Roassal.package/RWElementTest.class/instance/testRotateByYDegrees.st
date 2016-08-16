tests
testRotateByYDegrees
	| angle matrix |
	angle := 60.
	matrix :=WDMatrix3 yrot: angle degreesToRadians.
	element rotateByYDegrees: angle.
	self assert: (element orientationMatrix closeTo: matrix)