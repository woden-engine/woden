tests
testMakeTranslucent

	self assert: cube isOpaque.
	cube translucent.
	self deny: cube isOpaque.
	self assert: cube isTranslucent.
