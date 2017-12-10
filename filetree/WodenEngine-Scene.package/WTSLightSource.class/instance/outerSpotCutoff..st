accessing
outerSpotCutoff: anObject
	outerSpotCutoff := anObject.
	self isSpotLight ifTrue: [ 
		state outerCosCutoff: outerSpotCutoff degreeCos.
	].

