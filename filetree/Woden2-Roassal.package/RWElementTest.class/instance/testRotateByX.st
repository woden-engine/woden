tests
testRotateByX
	| angle matrix |
	angle := 60 degreesToRadians.
	matrix := WMMatrix3F xrot: angle.
	element rotateByX: angle.
	self assert: (element orientationMatrix closeTo: matrix)