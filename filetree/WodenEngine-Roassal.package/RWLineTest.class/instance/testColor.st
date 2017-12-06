tests
testColor

	| l |
	l := RWLine new.
	self assert: (l colorFor: nil) equals: l defaultColor