test layout
testSphereLayout2
	"RWSphereLayout is not implemented yet"

	"RWSphereLayout on: { element1 . element2 . element3 }.
	
	self deny: (element1 position length closeTo: 0.0).
	self assert: (element1 position length closeTo: element2 position length).
	self assert: (element2 position length closeTo: element3 position length).
	"