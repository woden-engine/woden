test layout
testCircleLayout
	| element4 |
	element4 := RWCube element.
	view add: element4.
	"element1 position: (R3Vector3 newX: 1 y: 1 z: 1)."

	RWCircleLayout on: { element1 . element2 . element3 . element4 }.
	
	self assert: element1 position equals: (WMVector3F x: 2.0 y: 0.0 z: 0.0).
	self assert: (element2 position closeTo: (WMVector3F x: 0.0 y: 2.0 z: 0.0)).
	self assert: (element3 position closeTo: (WMVector3F x: -2.0 y: 0.0 z: 0.0)).
	self assert: (element4 position closeTo: (WMVector3F x: 0.0 y: -2.0 z: 0.0)).