as yet unclassified
distortFactor: aRadius
	| r2 r4 |
	r2 := aRadius*aRadius.
	r4 := r2*r2.
	^ 1.0 + (r2*distortionCoefficients x) + (r4*distortionCoefficients y)