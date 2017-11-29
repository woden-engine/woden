tests
testElementFromModel
	| element |
	element := RWCube elementOn: 42.
	view add: element.
	self assert: (view elementFromModel: 42) equals: element