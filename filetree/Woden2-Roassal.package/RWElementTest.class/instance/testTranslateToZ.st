tests
testTranslateToZ

	self assert: element position equals: WMVector3F zero.
		
	element translateToZ: -3.0.
	self assert: element position equals: (WMVector3F x: 0.0 y: 0.0 z: -3.0).