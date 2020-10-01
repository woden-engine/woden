Extension { #name : #BabylonGenericTransform }

{ #category : #'*WodenEngine-Babylon' }
BabylonGenericTransform >> asFloat32x4x4 [
	^ Float32x4x4 new
		m11: sx asFloat; m12: shx asFloat; m14: x asFloat;
		m21: shy asFloat; m22: sy asFloat; m24: y asFloat;
		m33: 1.0;
		m41: w0; m42: w1; m44: w2;
		yourself
]
