tests
testMakeAlphaOverTranslucent

	self assert: cube isOpaque.
	cube alphaOverTranslucent.
	self deny: cube isOpaque.
	self deny: cube isTranslucent.
	self assert: cube isAlphaOverTranslucent.
