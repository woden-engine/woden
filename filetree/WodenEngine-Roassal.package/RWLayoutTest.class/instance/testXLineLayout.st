test layout
testXLineLayout
	RWXLineLayout on: { element1 . element2 . element3 }.
	
	self assert: element1 position x < element2 position x.
	self assert: element2 position x < element3 position x.

	self assert: element1 position y = element2 position y.
	self assert: element2 position y = element3 position y.

	self assert: element1 position z = element2 position z.
	self assert: element2 position z = element3 position z.
	