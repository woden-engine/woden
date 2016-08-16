tests
testRotateByZ
	| angle matrix |
	angle := 60 degreesToRadians.
	matrix :=WDMatrix3 zrot: angle.
	element rotateByZ: angle.
	self assert: (element orientationMatrix closeTo: matrix)