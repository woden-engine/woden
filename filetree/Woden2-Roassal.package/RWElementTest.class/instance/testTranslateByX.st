tests
testTranslateByX

	self assert: element position equals: WMVector3F zero.
		
	element translateByX: 2.0.
	self assert: element position equals: (WMVector3F x: 2.0 y: 0.0 z: 0.0).