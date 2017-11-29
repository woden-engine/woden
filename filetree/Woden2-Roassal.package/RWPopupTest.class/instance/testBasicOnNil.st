tests
testBasicOnNil

	| popup |
	popup := RWPopup new.
	self assert: (popup textFor: RWElement new) equals: 'nil'.