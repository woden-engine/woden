tests
testTranslateToY

	self assert: element position equals: WMVector3F zero.
		
	element translateToY: 2.0.
	self assert: element position equals: (WMVector3F x: 0.0 y: 2.0 z: 0.0).