Class {
	#name : #WDELevelElementTemplate,
	#superclass : #WDEPaletteElement,
	#category : #'WodenEngine-Editor-Model-Palettes'
}

{ #category : #'as yet unclassified' }
WDELevelElementTemplate >> activateInLevelSession: levelSession [
	levelSession activeLevelElementTemplate: self
]

{ #category : #testing }
WDELevelElementTemplate >> canBePlacedInLevel [
	^ true
]

{ #category : #'as yet unclassified' }
WDELevelElementTemplate >> instantiateInSectorLayer: sectorLayer placingInBox: box session: levelEditorSession [
]

{ #category : #'as yet unclassified' }
WDELevelElementTemplate >> instantiateInSectorLayer: sectorLayer placingInPoint: point session: levelEditorSession [
	^ false
]

{ #category : #testing }
WDELevelElementTemplate >> isPointElementTemplate [
	^ false
]
