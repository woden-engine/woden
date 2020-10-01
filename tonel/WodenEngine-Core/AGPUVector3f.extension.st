Extension { #name : #AGPUVector3f }

{ #category : #'*WodenEngine-Core' }
AGPUVector3f >> asFloat32x3 [
	^ Float32x3 x: self x y: self y z: self z
]
