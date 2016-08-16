tests
testPosition

	self assert: element position equals: WDVector3 zero.
	
	element translateToX: 1.0 y: 2.0 z: 3.0.
	self assert: element position equals: (WDVector3 newX: 1.0 y: 2.0 z: 3.0).