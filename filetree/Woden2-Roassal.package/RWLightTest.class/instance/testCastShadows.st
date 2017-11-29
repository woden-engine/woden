as yet unclassified
testCastShadows
	| light |
	light := RWSpotLight new.
	light castShadows: true.
	self assert: light castShadows