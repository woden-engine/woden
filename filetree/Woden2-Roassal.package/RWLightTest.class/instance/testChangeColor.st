as yet unclassified
testChangeColor
	| light |
	light := RWSpotLight new.
	light color: WDColor red.
	self assert: (light color closeTo: WDColor red).
	self assert: (light diffuse closeTo: WDColor red).
	self assert: (light specular closeTo: WDColor red).
