Class {
	#name : #WDCSmoothRamp,
	#superclass : #WDCLinearRamp,
	#category : #'WodenEngine-Core-Texture'
}

{ #category : #'as yet unclassified' }
WDCSmoothRamp >> interpolate: v1 with: v2 at: alpha [
	^ super interpolate: v1 with: v2 at: alpha cubicHemiteCurve
]
