as yet unclassified
testChangeColor
	| light |
	light := RWSpotLight new.
	light color: Color red.
	self assert: (light color closeTo: Color red).
	self assert: (light diffuse closeTo: Color red).
	self assert: (light specular closeTo: Color red).
