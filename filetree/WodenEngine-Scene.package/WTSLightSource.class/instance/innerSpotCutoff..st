accessing
innerSpotCutoff: anObject
	innerSpotCutoff := anObject.
	self isSpotLight ifTrue: [ 
		state innerCosCutoff: innerSpotCutoff degreeCos.
	]