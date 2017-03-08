tests
testTranslateBy

	self assert: element position equals: WMVector3F new.
		
	element translateBy: (WMVector3F x: 1.0 y: 2.0 z: 3.0).
	self assert: element position equals: (WMVector3F x: 1.0 y: 2.0 z: 3.0).