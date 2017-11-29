tests
testAddingElements
	| elements |
	elements := RWCube elementsOn: (1 to: 20).
	view addAll: elements.
	self assert: view elements size equals: 20.
	self assert: view numberOfElements equals: 20.