tests
testBoundingBox
	view add: RWCube element.
	self assert: (view boundingBox closeTo: (WDAABox  unitCube)).