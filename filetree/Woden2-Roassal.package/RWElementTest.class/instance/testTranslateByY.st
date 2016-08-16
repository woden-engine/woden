tests
testTranslateByY

	self assert: element position equals: WDVector3 zero.
		
	element translateByY: 2.0.
	self assert: element position equals: (WDVector3 newX: 0.0 y: 2.0 z: 0.0).