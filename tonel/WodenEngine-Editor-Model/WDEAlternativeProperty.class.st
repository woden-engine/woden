Class {
	#name : #WDEAlternativeProperty,
	#superclass : #WDEProperty,
	#instVars : [
		'alternatives'
	],
	#category : #'WodenEngine-Editor-Model-Properties'
}

{ #category : #accessing }
WDEAlternativeProperty >> alternatives [
	^ alternatives
]

{ #category : #accessing }
WDEAlternativeProperty >> alternatives: anObject [
	alternatives := anObject
]
