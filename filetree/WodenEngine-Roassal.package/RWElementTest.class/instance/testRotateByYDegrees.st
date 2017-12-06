tests
testRotateByYDegrees
	| angle matrix |
	angle := 60.
	matrix := WMMatrix3F yrot: angle degreesToRadians.
	element rotateByYDegrees: angle.
	self assert: (element orientationMatrix closeTo: matrix)