tests
testBasic

	| popup |
	popup := RWPopup new.
	self assert: (popup textFor: (RWElement new model: 'hello')) equals: 'hello'.