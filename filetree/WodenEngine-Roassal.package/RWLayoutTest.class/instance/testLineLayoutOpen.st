test layout
testLineLayoutOpen
	| window |
	RWYLineLayout on: { element1 . element2 . element3 }.
	
	self shouldnt: [ window :=  view open ] raise: Error.
	window close.