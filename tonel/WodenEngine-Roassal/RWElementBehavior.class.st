Class {
	#name : #RWElementBehavior,
	#superclass : #RWObject,
	#instVars : [
		'enabledBlock'
	],
	#category : #'WodenEngine-Roassal-Core'
}

{ #category : #adding }
RWElementBehavior >> addedInElement: anElement [
]

{ #category : #converting }
RWElementBehavior >> asRWElementBehavior [
	^ self
]

{ #category : #'as yet unclassified' }
RWElementBehavior >> enabledWhen: aBlock [
	enabledBlock := aBlock
]

{ #category : #testing }
RWElementBehavior >> isEnabledFor: anElement [
	^ (enabledBlock rwValue: anElement) ~~ false
]

{ #category : #'time simulation' }
RWElementBehavior >> simulateTime: delta onElement: anElement [
]
