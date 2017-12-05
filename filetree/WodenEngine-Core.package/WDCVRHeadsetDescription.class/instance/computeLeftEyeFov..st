as yet unclassified
computeLeftEyeFov: distorted
	^ distorted ifTrue: [self computeDistortedLeftEyeFOV] ifFalse: [ self computeUndistortedLeftEyeFOV ]