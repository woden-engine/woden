Class {
	#name : #WDELevelElementDimensionalityMode,
	#superclass : #Object,
	#classInstVars : [
		'uniqueInstance'
	],
	#category : #'WodenEngine-Editor-Model-Level'
}

{ #category : #'as yet unclassified' }
WDELevelElementDimensionalityMode class >> mode2D [	
	^ WDELevelElement2DDimensionalityMode uniqueInstance
]

{ #category : #'as yet unclassified' }
WDELevelElementDimensionalityMode class >> mode3D [	
	^ WDELevelElement3DDimensionalityMode uniqueInstance
]

{ #category : #accessing }
WDELevelElementDimensionalityMode class >> uniqueInstance [
	^ uniqueInstance ifNil: [ uniqueInstance := self new ]
]

{ #category : #testing }
WDELevelElementDimensionalityMode >> is2D [
	^ false
]

{ #category : #testing }
WDELevelElementDimensionalityMode >> is3D [
	^ false
]

{ #category : #'as yet unclassified' }
WDELevelElementDimensionalityMode >> sanitizePosition: aPosition [
	^ aPosition
]
