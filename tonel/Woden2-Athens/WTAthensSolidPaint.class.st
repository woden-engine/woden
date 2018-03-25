Class {
	#name : #WTAthensSolidPaint,
	#superclass : #AthensPaint,
	#instVars : [
		'color'
	],
	#category : 'Woden2-Athens-Paint'
}

{ #category : #converting }
WTAthensSolidPaint >> asColor [
	^ color
]

{ #category : #rendering }
WTAthensSolidPaint >> athensFillPath: path on: aCanvas [
	^ aCanvas surface fillPath: path withSolidColor: color
]

{ #category : #accessing }
WTAthensSolidPaint >> color [
	^ color
]

{ #category : #accessing }
WTAthensSolidPaint >> color: anObject [
	color := anObject
]
