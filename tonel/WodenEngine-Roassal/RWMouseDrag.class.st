Class {
	#name : #RWMouseDrag,
	#superclass : #RWMouseEvent,
	#instVars : [
		'delta'
	],
	#category : 'WodenEngine-Roassal-Events'
}

{ #category : #accessing }
RWMouseDrag >> delta [
	
	^ delta
]

{ #category : #accessing }
RWMouseDrag >> delta: anObject [
	
	delta := anObject
]
