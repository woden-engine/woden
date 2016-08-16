tests
testTranslateBy

	self assert: element position equals: WDVector3 zero.
		
	element translateBy: (WDVector3 x: 1.0 y: 2.0 z: 3.0).
	self assert: element position equals: (WDVector3 newX: 1.0 y: 2.0 z: 3.0).