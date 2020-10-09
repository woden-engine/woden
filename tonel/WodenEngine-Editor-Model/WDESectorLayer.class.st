Class {
	#name : #WDESectorLayer,
	#superclass : #WDELevelElement,
	#instVars : [
		'sector',
		'elements',
		'defaultMinZ',
		'defaultMaxZ'
	],
	#category : #'WodenEngine-Editor-Model'
}

{ #category : #accessing }
WDESectorLayer >> children [
	^ elements
]

{ #category : #'as yet unclassified' }
WDESectorLayer >> createPointEntity: entityClassName at: entityLocation [
]

{ #category : #'as yet unclassified' }
WDESectorLayer >> createSolidEntity: entityClassName boxMin: boxMin max: boxMax color: colors [
]

{ #category : #accessing }
WDESectorLayer >> defaultMaxZ [
	^ defaultMaxZ
]

{ #category : #accessing }
WDESectorLayer >> defaultMaxZ: anObject [
	defaultMaxZ := anObject
]

{ #category : #accessing }
WDESectorLayer >> defaultMinZ [
	^ defaultMinZ
]

{ #category : #accessing }
WDESectorLayer >> defaultMinZ: anObject [
	defaultMinZ := anObject
]

{ #category : #'as yet unclassified' }
WDESectorLayer >> defaultThickness: defaultThickness [
	self
		defaultMinZ: defaultThickness * -0.5;
		defaultMaxZ: defaultThickness * 0.5
]

{ #category : #accessing }
WDESectorLayer >> elements: anObject [
	elements := anObject
]

{ #category : #initialization }
WDESectorLayer >> initialize [
	super initialize.
	elements := OrderedCollection new.
	defaultMinZ := -1.0.
	defaultMaxZ := -1.0.
]

{ #category : #accessing }
WDESectorLayer >> sector [
	^ sector
]

{ #category : #accessing }
WDESectorLayer >> sector: anObject [
	sector := anObject
]
