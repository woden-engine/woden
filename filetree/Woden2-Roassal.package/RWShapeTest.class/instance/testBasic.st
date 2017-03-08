tests
testBasic

	self assert: (cube colorFor: element) class equals: Color.
	self assert: cube isOpaque.
	self deny: cube isTranslucent.
	self deny: cube isAlphaOverTranslucent.