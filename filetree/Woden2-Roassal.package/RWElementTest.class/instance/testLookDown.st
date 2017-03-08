tests
testLookDown

	self assert: element orientationMatrix equals: WMMatrix3F identity.
	element lookDown.
	self assert: (element orientationMatrix thirdRow closeTo: (WMVector3F x: 0.0 y: -1.0 z: 0.0))