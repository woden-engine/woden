Class {
	#name : #WDCSmoothRamp,
	#superclass : #WDCLinearRamp,
	#category : #'WodenEngine-Core-Texture'
}

{ #category : #'dastrel color ramp' }
WDCSmoothRamp >> constructDastrelAlphaLeft: leftEdgePosition right: rightEdgePosition [
	^ 'smoothstep({1}f, {2}f, x);' format: { leftEdgePosition asFloat . (rightEdgePosition - leftEdgePosition) reciprocal asFloat}.
]

{ #category : #'as yet unclassified' }
WDCSmoothRamp >> interpolate: v1 with: v2 at: alpha [
	^ super interpolate: v1 with: v2 at: alpha cubicHemiteCurve
]
