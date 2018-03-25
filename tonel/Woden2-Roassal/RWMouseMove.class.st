Class {
	#name : #RWMouseMove,
	#superclass : #RWMouseEvent,
	#instVars : [
		'delta'
	],
	#category : 'Woden2-Roassal-Events'
}

{ #category : #accessing }
RWMouseMove >> delta [
	
	^ delta
]

{ #category : #accessing }
RWMouseMove >> delta: anObject [
	
	delta := anObject
]
