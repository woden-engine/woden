tests
testGrowingCubes

	| v es |
	v := RWView new.
	shape := RWCube new size: #yourself.
	es := shape elementsOn: (1 to: 3 by: 0.5).
	v addAll: es. 
	
	"We cannot test much because Renderable does not have bounding box"
	self assert: (es first boundingBox extent closeTo: (WMVector3F x: 1.0 y: 1.0 z: 1.0))