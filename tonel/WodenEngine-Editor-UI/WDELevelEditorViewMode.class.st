Class {
	#name : #WDELevelEditorViewMode,
	#superclass : #Object,
	#instVars : [
		'view'
	],
	#pools : [
		'OSKeySymbols'
	],
	#category : #'WodenEngine-Editor-UI-ViewMode'
}

{ #category : #'instance creation' }
WDELevelEditorViewMode class >> for: aView [
	^ self new view: aView; yourself
]

{ #category : #accessing }
WDELevelEditorViewMode >> level [
	^ self model level
]

{ #category : #accessing }
WDELevelEditorViewMode >> levelEditorSession [
	^ self model levelEditorSession
]

{ #category : #accessing }
WDELevelEditorViewMode >> model [
	^ view model
]

{ #category : #'event handling' }
WDELevelEditorViewMode >> onKeyDown: event [
]

{ #category : #'event handling' }
WDELevelEditorViewMode >> onKeyUp: event [
]

{ #category : #'event handling' }
WDELevelEditorViewMode >> onMouseButtonPress: event [
]

{ #category : #'event handling' }
WDELevelEditorViewMode >> onMouseButtonRelease: event [
]

{ #category : #'event handling' }
WDELevelEditorViewMode >> onMouseMove: event [
]

{ #category : #'event handling' }
WDELevelEditorViewMode >> onMouseWheel: event [
]

{ #category : #accessing }
WDELevelEditorViewMode >> view [
	^ view
]

{ #category : #accessing }
WDELevelEditorViewMode >> view: anObject [
	view := anObject
]
