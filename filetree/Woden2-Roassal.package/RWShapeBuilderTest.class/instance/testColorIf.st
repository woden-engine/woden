tests
testColorIf

	| e |
	builder box 
		if: true color: Color blue;
		if: true color: Color red.
	e := builder elementOn: 1.
	
	self assert: (e shape colorFor: e) equals: Color red.
	self assert: e trachelShape color equals: Color red.