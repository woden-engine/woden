Class {
	#name : #WDAMouseDragEvent,
	#superclass : #OSMouseMoveEvent,
	#instVars : [
		'startButton',
		'startPosition'
	],
	#category : #'WodenEngine-Core-Application-Events'
}

{ #category : #visitor }
WDAMouseDragEvent >> accept: aVisitor [
	^ aVisitor visitMouseDragEvent: self
]

{ #category : #accessing }
WDAMouseDragEvent >> startButton [

	^ startButton
]

{ #category : #accessing }
WDAMouseDragEvent >> startButton: anObject [

	startButton := anObject
]

{ #category : #accessing }
WDAMouseDragEvent >> startPosition [

	^ startPosition
]

{ #category : #accessing }
WDAMouseDragEvent >> startPosition: anObject [

	startPosition := anObject
]
