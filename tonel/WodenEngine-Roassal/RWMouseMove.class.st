Class {
	#name : #RWMouseMove,
	#superclass : #RWMouseEvent,
	#instVars : [
		'delta'
	],
	#category : 'WodenEngine-Roassal-Events'
}

{ #category : #accessing }
RWMouseMove >> delta [
	
	^ delta
]

{ #category : #accessing }
RWMouseMove >> delta: anObject [
	
	delta := anObject
]
