tests
testRotateByY
	| angle matrix |
	angle := 60 degreesToRadians.
	matrix :=WDMatrix3 yrot: angle.
	element rotateByY: angle.
	self assert: (element orientationMatrix closeTo: matrix)