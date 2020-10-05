Class {
	#name : #WDESector,
	#superclass : #WDELevelElement,
	#instVars : [
		'level',
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
]

{ #category : #accessing }
WDESector >> level [
	^ level
]

{ #category : #accessing }
WDESector >> level: anObject [
	level := anObject
]
