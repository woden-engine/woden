tests
testHasInteraction

	| e |
	e := RWElement new.
	self deny: (e hasInteraction: RWMenuActivable).
	e @ RWMenuActivable.
	self assert: (e hasInteraction: RWMenuActivable).