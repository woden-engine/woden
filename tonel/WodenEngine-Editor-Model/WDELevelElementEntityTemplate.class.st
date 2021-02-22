Class {
	#name : #WDELevelElementEntityTemplate,
	#superclass : #WDELevelElementTemplate,
	#instVars : [
		'prototype'
	],
	#category : #'WodenEngine-Editor-Model-Palettes'
}

{ #category : #'as yet unclassified' }
WDELevelElementEntityTemplate >> instantiateInSectorLayer: sectorLayer placingInBox: box session: levelSession [
	| oldSelection element |
	oldSelection := levelSession selection.
	levelSession
		doWith: [
			element := prototype is2DLevelElement ifTrue: [
				sectorLayer instanceEntityPrototype: prototype andPlaceInRectangle: box asRectangleXY
			] ifFalse: [ 
				sectorLayer instanceEntityPrototype: prototype andPlaceInBox: box
			].
			levelSession selection: (WDELevelEditorSelection for: {element}).
		]
		undoWith: [
			levelSession selection: oldSelection.
			element removeFromParent.
		]
]

{ #category : #'as yet unclassified' }
WDELevelElementEntityTemplate >> instantiateInSectorLayer: sectorLayer placingInPoint: point session: levelSession [
	| oldSelection element |
	oldSelection := levelSession selection.
	levelSession
		doWith: [
			element := sectorLayer instanceEntityPrototype: prototype andPlaceAt: point.
			levelSession selection: (WDELevelEditorSelection for: {element}).
		]
		undoWith: [
			levelSession selection: oldSelection.
			element removeFromParent.
		].
	^ true
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
