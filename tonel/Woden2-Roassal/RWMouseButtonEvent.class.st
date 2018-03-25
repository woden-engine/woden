Class {
	#name : #RWMouseButtonEvent,
	#superclass : #RWMouseEvent,
	#instVars : [
		'button'
	],
	#category : 'Woden2-Roassal-Events'
}

{ #category : #accessing }
RWMouseButtonEvent >> button [
	
	^ button
]

{ #category : #accessing }
RWMouseButtonEvent >> button: anObject [
	
	button := anObject
]
