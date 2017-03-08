tests
testTranslateToX

	self assert: element position equals: WMVector3F zero.
		
	element translateToX: 5.0.
	self assert: element position equals: (WMVector3F x: 5.0 y: 0.0 z: 0.0).