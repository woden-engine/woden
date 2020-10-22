Class {
	#name : #WDELevelElementEntityTemplate,
	#superclass : #WDELevelElementTemplate,
	#instVars : [
		'prototype'
	],
	#category : #'WodenEngine-Editor-Model-Palettes'
}

{ #category : #'as yet unclassified' }
WDELevelElementEntityTemplate >> instantiateInSectorLayer: sectorLayer placingInBox: box [
	prototype is2DLevelElement ifTrue: [
		sectorLayer instanceEntityPrototype: prototype andPlaceInRectangle: box asRectangleXY
	] ifFalse: [ 
		sectorLayer instanceEntityPrototype: prototype andPlaceInBox: box
	].
]

{ #category : #'as yet unclassified' }
WDELevelElementEntityTemplate >> instantiateInSectorLayer: sectorLayer placingInPoint: point [
	sectorLayer instanceEntityPrototype: prototype andPlaceAt: point
]

{ #category : #testing }
WDELevelElementEntityTemplate >> isPointElementTemplate [
	^ prototype isPointEntity
]

{ #category : #accessing }
WDELevelElementEntityTemplate >> prototype [
	^ prototype
]

{ #category : #accessing }
WDELevelElementEntityTemplate >> prototype: anObject [
	prototype := anObject
]
