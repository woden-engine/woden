tests
testBackgroundColor
	self assert: (view backgroundColor closeTo: WDColor black).
	view backgroundColor: WDColor red.
	self assert: (view backgroundColor closeTo: WDColor red).