Class {
	#name : #RWKeyEvent,
	#superclass : #RWEvent,
	#instVars : [
		'symbol'
	],
	#category : 'Woden2-Roassal-Events'
}

{ #category : #accessing }
RWKeyEvent >> symbol [
	
	^ symbol
]

{ #category : #accessing }
RWKeyEvent >> symbol: anObject [
	
	symbol := anObject
]
