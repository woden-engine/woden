Class {
	#name : #WTAthensLinearGradientPaint,
	#superclass : #WTAthensGradientPaint,
	#instVars : [
		'start',
		'stop'
	],
	#category : 'Woden2-Athens-Paint'
}

{ #category : #'as yet unclassified' }
WTAthensLinearGradientPaint class >> colorRamp: aColorRamp start: aStartPoint stop: aStopPoint [
	^ self new colorRamp: aColorRamp; start: aStartPoint; stop: aStopPoint; yourself
]

{ #category : #rendering }
WTAthensLinearGradientPaint >> athensFillPath: path on: aCanvas [
	^ aCanvas surface fillPath: path withLinearGradient: self
]

{ #category : #accessing }
WTAthensLinearGradientPaint >> start [
	^ start
]

{ #category : #accessing }
WTAthensLinearGradientPaint >> start: anObject [
	start := anObject
]

{ #category : #accessing }
WTAthensLinearGradientPaint >> stop [
	^ stop
]

{ #category : #accessing }
WTAthensLinearGradientPaint >> stop: anObject [
	stop := anObject
]
