as yet unclassified
distortRadiusDerivative: radius
	| r2 r4 |
	r2 := radius*radius.
	r4 := r2*r2.
	^ 1.0 + (3.0*distortionCoefficients x *r2) + (5.0*distortionCoefficients x *r4)