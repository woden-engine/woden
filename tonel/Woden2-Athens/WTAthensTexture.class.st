Class {
	#name : #WTAthensTexture,
	#superclass : #Object,
	#instVars : [
		'texture',
		'binding'
	],
	#category : 'Woden2-Athens'
}

{ #category : #converting }
WTAthensTexture >> asAthensPaintOn: aCanvas [
	^ self
]

{ #category : #'as yet unclassified' }
WTAthensTexture >> athensFillRectangle: rectangle on: canvas [
	canvas surface fillRectangle: rectangle withTexture: self
]

{ #category : #accessing }
WTAthensTexture >> binding [
	^ binding
]

{ #category : #accessing }
WTAthensTexture >> binding: anObject [
	binding := anObject
]

{ #category : #accessing }
WTAthensTexture >> texture [
	^ texture
]

{ #category : #accessing }
WTAthensTexture >> texture: anObject [
	texture := anObject
]
