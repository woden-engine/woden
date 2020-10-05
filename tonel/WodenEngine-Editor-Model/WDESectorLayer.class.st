Class {
	#name : #WDESectorLayer,
	#superclass : #WDELevelElement,
	#instVars : [
		'sector',
		'elements'
	],
	#category : #'WodenEngine-Editor-Model'
}

{ #category : #accessing }
WDESectorLayer >> children [
	^ elements
]

{ #category : #accessing }
WDESectorLayer >> elements: anObject [
	elements := anObject
]

{ #category : #initialization }
WDESectorLayer >> initialize [
	super initialize.
	elements := OrderedCollection new.
]

{ #category : #accessing }
WDESectorLayer >> sector [
	^ sector
]

{ #category : #accessing }
WDESectorLayer >> sector: anObject [
	sector := anObject
]
