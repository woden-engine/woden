as yet unclassified
inverseDistortRadius: distortedRadius
	| radius nextRadius eps |
	radius := distortedRadius.
	[
		nextRadius := radius - (((self distortRadius: radius) - distortedRadius) / (self distortRadiusDerivative: radius)).
		eps := (radius - nextRadius).
		radius := nextRadius
	] doWhileFalse: [ InverseDistortRadiusEpsilon negated <= eps and: [ eps <= InverseDistortRadiusEpsilon ]  ].
	^ radius