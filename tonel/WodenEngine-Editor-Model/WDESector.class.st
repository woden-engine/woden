Class {
	#name : #WDESector,
	#superclass : #WDELevelElement,
	#instVars : [
		'level',
		'isSector2D',
		'layers'
	],
	#category : #'WodenEngine-Editor-Model'
}

{ #category : #visiting }
WDESector >> accept: visitor [
	^ visitor visitSector: self
]

{ #category : #adding }
WDESector >> addLayer: aLayer [
	self assert: aLayer sector isNil.
	layers add: aLayer.
	aLayer sector: self

]

{ #category : #accessing }
WDESector >> children [
	^ layers
]

{ #category : #initialization }
WDESector >> initialize [
	super initialize.
	layers := OrderedCollection new.
	isSector2D := false.
]

{ #category : #testing }
WDESector >> isInSector2D [
	^ true
]

{ #category : #testing }
WDESector >> isSector [
	^ true
]

{ #category : #accessing }
WDESector >> isSector2D [
	^ isSector2D
]

{ #category : #accessing }
WDESector >> isSector2D: anObject [
	isSector2D := anObject
]

{ #category : #accessing }
WDESector >> layers [
	^ layers
]

{ #category : #accessing }
WDESector >> level [
	^ level
]

{ #category : #accessing }
WDESector >> level: anObject [
	level := anObject
]
