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

{ #category : #accessing }
WDESector >> isSector2D [
	^ isSector2D
]

{ #category : #accessing }
WDESector >> isSector2D: anObject [
	isSector2D := anObject
]

{ #category : #accessing }
WDESector >> layers: anObject [
	layers := anObject
]

{ #category : #accessing }
WDESector >> level [
	^ level
]

{ #category : #accessing }
WDESector >> level: anObject [
	level := anObject
]
