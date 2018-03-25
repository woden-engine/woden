Class {
	#name : #RWKeyEvent,
	#superclass : #RWEvent,
	#instVars : [
		'symbol'
	],
	#category : 'WodenEngine-Roassal-Events'
}

{ #category : #accessing }
RWKeyEvent >> symbol [
	
	^ symbol
]

{ #category : #accessing }
RWKeyEvent >> symbol: anObject [
	
	symbol := anObject
]
