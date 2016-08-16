test layout
testSphereLayout
	"RWSphereLayout is not implemented yet"
"	element1 position: (WDVector3 x: 1 y: 1 z: 1).
	RWSphereLayout on: { element1 }.
	
	self assert: (element1 position closeTo: (WDVector3 zero)).
	"