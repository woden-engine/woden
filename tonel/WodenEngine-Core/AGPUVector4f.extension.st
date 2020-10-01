Extension { #name : #AGPUVector4f }

{ #category : #'*WodenEngine-Core' }
AGPUVector4f >> asFloat32x3 [
	^ Float32x3 x: self x y: self y z: self z
]

{ #category : #'*WodenEngine-Core' }
AGPUVector4f >> asFloat32x4 [
	^ Float32x4 x: self x y: self y z: self z w: self w
]
