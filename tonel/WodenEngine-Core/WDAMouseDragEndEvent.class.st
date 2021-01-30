Class {
	#name : #WDAMouseDragEndEvent,
	#superclass : #OSMouseButtonEvent,
	#instVars : [
		'startButton',
		'startPosition'
	],
	#category : #'WodenEngine-Core-Application-Events'
}

{ #category : #visitor }
WDAMouseDragEndEvent >> accept: aVisitor [
	^ aVisitor visitMouseDragEndEvent: self
]

{ #category : #accessing }
WDAMouseDragEndEvent >> startButton [

	^ startButton
]

{ #category : #accessing }
WDAMouseDragEndEvent >> startButton: anObject [

	startButton := anObject
]

{ #category : #accessing }
WDAMouseDragEndEvent >> startPosition [

	^ startPosition
]

{ #category : #accessing }
WDAMouseDragEndEvent >> startPosition: anObject [

	startPosition := anObject
]
