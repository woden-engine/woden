Extension { #name : #BabylonGenericTransform }

{ #category : #'*WodenEngine-Babylon' }
BabylonGenericTransform >> asFloat32x4x4 [
	^ Float32x4x4 rows: {
		sx . shx . 0 . x.
		shy . sy . 0. y.
		0. 0. 1. 0.
		w0. w1. 0. w2.
	}
]
