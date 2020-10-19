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

{ #category : #'instance creation' }
WDELevelElementDimensionalityMode class >> named: aName [
	aName = '2D' ifTrue: [ ^ self mode2D ].
	aName = '3D' ifTrue: [ ^ self mode3D ].
	^ self mode3D
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

{ #category : #accessing }
WDELevelElementDimensionalityMode >> name [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
WDELevelElementDimensionalityMode >> sanitizePosition: aPosition [
	^ aPosition
]
