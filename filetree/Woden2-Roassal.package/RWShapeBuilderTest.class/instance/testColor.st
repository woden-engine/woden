tests
testColor

	| e |
	builder rectangle color: Color blue.
	e := builder elementOn: 1.
	
	self assert: (e shape colorFor: e) equals: Color blue.
	self assert: e trachelShape color equals: Color blue.