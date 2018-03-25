Class {
	#name : #RWMouseWheel,
	#superclass : #RWMouseEvent,
	#instVars : [
		'delta'
	],
	#category : 'Woden2-Roassal-Events'
}

{ #category : #accessing }
RWMouseWheel >> delta [
	
	^ delta
]

{ #category : #accessing }
RWMouseWheel >> delta: anObject [
	
	delta := anObject
]
