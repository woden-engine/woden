Class {
	#name : #RWMouseWheel,
	#superclass : #RWMouseEvent,
	#instVars : [
		'delta'
	],
	#category : 'WodenEngine-Roassal-Events'
}

{ #category : #accessing }
RWMouseWheel >> delta [
	
	^ delta
]

{ #category : #accessing }
RWMouseWheel >> delta: anObject [
	
	delta := anObject
]
