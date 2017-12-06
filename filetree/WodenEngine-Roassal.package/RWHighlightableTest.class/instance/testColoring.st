tests
testColoring

	| v es |
	v := RWView new.
	
	es := ((RWCube new size: 1)) elementsOn: (1 to: 16).

	RWCubeLayout on: es.
	v addAll: es.

	es first color: Color blue.
	self assert: es second renderable color equals: Color white.