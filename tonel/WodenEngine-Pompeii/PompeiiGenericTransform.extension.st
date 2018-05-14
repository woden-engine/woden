Extension { #name : #PompeiiGenericTransform }

{ #category : #'*WodenEngine-Pompeii' }
PompeiiGenericTransform >> asWMMatrix4F [
	^ WMMatrix4F new
		m11: sx asFloat; m12: shx asFloat; m14: x asFloat;
		m21: shy asFloat; m22: sy asFloat; m24: y asFloat;
		m33: 1.0;
		m41: w0; m42: w1; m44: w2;
		yourself
]
