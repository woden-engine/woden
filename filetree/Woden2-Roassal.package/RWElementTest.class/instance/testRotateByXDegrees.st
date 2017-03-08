tests
testRotateByXDegrees
	| angle matrix |
	angle := 60.
	matrix := WMMatrix3F xrot: angle degreesToRadians.
	element rotateByXDegrees: angle.
	self assert: (element orientationMatrix closeTo: matrix)