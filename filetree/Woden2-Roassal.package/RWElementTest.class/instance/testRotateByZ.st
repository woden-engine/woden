tests
testRotateByZ
	| angle matrix |
	angle := 60 degreesToRadians.
	matrix := WMMatrix3F zrot: angle.
	element rotateByZ: angle.
	self assert: (element orientationMatrix closeTo: matrix)