tests
testTranslateByZ

	self assert: element position equals: WMVector3F zero.
		
	element translateByZ: 2.0.
	self assert: element position equals: (WMVector3F x: 0.0 y: 0.0 z: 2.0).