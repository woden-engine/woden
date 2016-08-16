test connected edges
testConnectedEdges01

	| e1 e2 l |
	e1 := RWCube element.
	e2 := RWCube element.
	self deny: (e1 isConnectedTo: e2).
	self deny: (e2 isConnectedTo: e1).
	
	l := RWLine edgeFrom: e1 to: e2.
	self assert: (e1 isConnectedTo: e2).
	self assert: (e2 isConnectedTo: e1).

	self assert: (e1 isDirectlyConnectedTo: e2).
	self deny: (e2 isDirectlyConnectedTo: e1).
