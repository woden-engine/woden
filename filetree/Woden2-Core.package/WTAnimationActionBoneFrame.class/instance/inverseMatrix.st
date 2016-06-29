as yet unclassified
inverseMatrix
	| inverseOrientation |
	inverseOrientation := rotation asWMMatrix3F transposed.
	^ WMMatrix4F mat3: inverseOrientation translation: (inverseOrientation transformVector3: translation negated)