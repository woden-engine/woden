tests
testTranslateTo

	self assert: element position equals: WMVector3F zero.
	element translateToX: 1.0 y: 2.0 z: 3.0.
	self assert: element position equals: (WMVector3F x: 1.0 y: 2.0 z: 3.0).