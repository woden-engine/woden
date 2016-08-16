tests
testTranslateToX

	self assert: element position equals: WDVector3 zero.
		
	element translateToX: 5.0.
	self assert: element position equals: (WDVector3 newX: 5.0 y: 0.0 z: 0.0).