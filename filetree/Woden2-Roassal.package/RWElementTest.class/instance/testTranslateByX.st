tests
testTranslateByX

	self assert: element position equals: WDVector3 zero.
		
	element translateByX: 2.0.
	self assert: element position equals: (WDVector3 newX: 2.0 y: 0.0 z: 0.0).