Class {
	#name : #WDEGameSettings,
	#superclass : #Object,
	#category : #'WodenEngine-Editor-Model-GameSettings'
}

{ #category : #'as yet unclassified' }
WDEGameSettings class >> allSettings [
	^ self withAllSubclasses
		reject: [ :each | each isAbstract  ]
		thenCollect: [ :each | each new ]
]

{ #category : #accessing }
WDEGameSettings class >> default [
	^ WDEWodenGameSettings new
]

{ #category : #testing }
WDEGameSettings class >> isAbstract [
	^ self == WDEGameSettings
]

{ #category : #accessing }
WDEGameSettings >> name [
	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
WDEGameSettings >> playLevelInSession: levelEditorSession [
	self inform: 'TODO: play level in editor session.'
]

{ #category : #palettes }
WDEGameSettings >> topLevelElementTemplateCategories [
	^ #()
]

{ #category : #palettes }
WDEGameSettings >> topMaterialPaletteCategories [
	^ #()
]
