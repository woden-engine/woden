as yet unclassified
testNew
	| light |
	light := RWSpotLight new.
	self assert: (light diffuse closeTo: Color lightGray).
	self assert: (light specular closeTo: Color lightGray).
	self assert: light castShadows not.
	self assert: light influenceRadius > 0.