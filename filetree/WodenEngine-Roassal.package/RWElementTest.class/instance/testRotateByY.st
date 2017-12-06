tests
testRotateByY
	| angle matrix |
	angle := 60 degreesToRadians.
	matrix := WMMatrix3F yrot: angle.
	element rotateByY: angle.
	self assert: (element orientationMatrix closeTo: matrix)