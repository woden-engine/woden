tests
testAddingElement
	| element |
	element := RWCube element.
	view add: element.
	self assert: view elements size equals: 1