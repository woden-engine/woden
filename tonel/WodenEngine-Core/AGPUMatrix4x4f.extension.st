Extension { #name : #AGPUMatrix4x4f }

{ #category : #'*WodenEngine-Core' }
AGPUMatrix4x4f >> asReversibleAffineTransform3dF32 [
	| matrix translation |
	matrix := Float32x3x3 columns: {
		self c1 asFloat32x3.
		self c2 asFloat32x3.
		self c3 asFloat32x3
	}.
	translation := self c4 asFloat32x3.
	^ ReversibleAffineTransform3dF32 identity orthonormal: matrix translation: translation
]
