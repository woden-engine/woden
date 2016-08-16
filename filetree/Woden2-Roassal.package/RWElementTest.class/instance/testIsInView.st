tests
testIsInView

	| e v |
	e := RWElement new.
	self assert: e view isNil.
	
	v := RWView new.
	v add: e.
	self assert: e view equals: v