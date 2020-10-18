Class {
	#name : #WDELevelElementTemplate,
	#superclass : #Object,
	#instVars : [
		'name'
	],
	#category : #'WodenEngine-Editor-Model-Templates'
}

{ #category : #converting }
WDELevelElementTemplate >> asLevelElementTemplate [
	^ self
]

{ #category : #accessing }
WDELevelElementTemplate >> children [
	^ #()
]

{ #category : #'as yet unclassified' }
WDELevelElementTemplate >> instantiateInSectorLayer: sectorLayer placingInBox: box [
]

{ #category : #'as yet unclassified' }
WDELevelElementTemplate >> instantiateInSectorLayer: sectorLayer placingInPoint: point [
]

{ #category : #testing }
WDELevelElementTemplate >> isPointElementTemplate [
	^ false
]

{ #category : #accessing }
WDELevelElementTemplate >> name [
	^ name
]

{ #category : #accessing }
WDELevelElementTemplate >> name: anObject [
	name := anObject
]
