tests
testLookDown

	self assert: element orientationMatrix equals: WDMatrix3 identity.
	element lookDown.
	self assert: (element orientationMatrix thirdRow closeTo: (WDVector3 newX: 0.0 y: -1.0 z: 0.0))