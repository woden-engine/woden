tests
testTranslateToZ

	self assert: element position equals: WDVector3 zero.
		
	element translateToZ: -3.0.
	self assert: element position equals: (WDVector3 newX: 0.0 y: 0.0 z: -3.0).