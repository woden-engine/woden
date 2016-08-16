tests
testRotateByX
	| angle matrix |
	angle := 60 degreesToRadians.
	matrix :=WDMatrix3 xrot: angle.
	element rotateByX: angle.
	self assert: (element orientationMatrix closeTo: matrix)