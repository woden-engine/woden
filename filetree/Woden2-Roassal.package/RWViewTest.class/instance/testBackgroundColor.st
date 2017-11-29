tests
testBackgroundColor
	self assert: (view backgroundColor closeTo: Color black).
	view backgroundColor: Color red.
	self assert: (view backgroundColor closeTo: Color red).