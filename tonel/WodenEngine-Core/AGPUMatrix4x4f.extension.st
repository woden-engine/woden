Extension { #name : #AGPUMatrix4x4f }

{ #category : #'*WodenEngine-Core' }
AGPUMatrix4x4f >> asWMReversibleAffineTransformF [
	| matrix translation |
	matrix := WMMatrix3F c1: self c1 asWMVector3F c2: self c2 asWMVector3F c3: self c3 asWMVector3F.
	translation := self c4 asWMVector3F.
	^ WMReversibleAffineTransformF identity orthonormal: matrix translation: translation
]
