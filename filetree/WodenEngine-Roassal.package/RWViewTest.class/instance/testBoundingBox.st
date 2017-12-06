tests
testBoundingBox
	view add: RWCube element.
	self assert: (view boundingBox closeTo: (WMBox3DF unitCube)).