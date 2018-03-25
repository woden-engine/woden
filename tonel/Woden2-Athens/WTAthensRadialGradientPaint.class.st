Class {
	#name : #WTAthensRadialGradientPaint,
	#superclass : #WTAthensGradientPaint,
	#instVars : [
		'center',
		'radius',
		'focalPoint'
	],
	#category : 'Woden2-Athens-Paint'
}

{ #category : #'as yet unclassified' }
WTAthensRadialGradientPaint class >> colorRamp: colorRamp center: aCenter focalPoint: focalPoint radius: radius [
	^ self new colorRamp: colorRamp; center: aCenter; focalPoint: focalPoint; radius: radius; yourself
]

{ #category : #rendering }
WTAthensRadialGradientPaint >> athensFillPath: path on: aCanvas [
	^ aCanvas surface fillPath: path withRadialGradient: self
]

{ #category : #accessing }
WTAthensRadialGradientPaint >> center [
	^ center
]

{ #category : #accessing }
WTAthensRadialGradientPaint >> center: anObject [
	center := anObject
]

{ #category : #accessing }
WTAthensRadialGradientPaint >> focalPoint [
	^ focalPoint
]

{ #category : #accessing }
WTAthensRadialGradientPaint >> focalPoint: anObject [
	focalPoint := anObject
]

{ #category : #accessing }
WTAthensRadialGradientPaint >> radius [
	^ radius
]

{ #category : #accessing }
WTAthensRadialGradientPaint >> radius: anObject [
	radius := anObject
]
