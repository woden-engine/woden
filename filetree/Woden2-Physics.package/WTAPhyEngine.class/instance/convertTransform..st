rendering
convertTransform: transform
	| matrix translation |
	matrix := self convertMatrix3: transform rotation.
	translation := self convertVector3: transform origin.
	^ WMReversibleAffineTransformF new orthonormal: matrix translation: translation