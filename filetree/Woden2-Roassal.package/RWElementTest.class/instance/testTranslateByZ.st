tests
testTranslateByZ

	self assert: element position equals: WDVector3 zero.
		
	element translateByZ: 2.0.
	self assert: element position equals: (WDVector3 newX: 0.0 y: 0.0 z: 2.0).