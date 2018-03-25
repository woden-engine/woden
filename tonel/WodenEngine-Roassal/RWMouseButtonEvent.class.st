Class {
	#name : #RWMouseButtonEvent,
	#superclass : #RWMouseEvent,
	#instVars : [
		'button'
	],
	#category : 'WodenEngine-Roassal-Events'
}

{ #category : #accessing }
RWMouseButtonEvent >> button [
	
	^ button
]

{ #category : #accessing }
RWMouseButtonEvent >> button: anObject [
	
	button := anObject
]
