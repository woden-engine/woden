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

{ #category : #'as yet unclassified' }
WDELevelEditorViewMode >> cameraXYDeltaToWorld: delta [
	^ self view cameraXYDeltaToWorld: delta
]

{ #category : #'as yet unclassified' }
WDELevelEditorViewMode >> cameraXYDeltaToWorld: delta distance: screenDistance [
	^ self view cameraXYDeltaToWorld: delta distance: screenDistance
]

{ #category : #'as yet unclassified' }
WDELevelEditorViewMode >> cameraXYToWorld: position distance: distance [
	^ self view cameraXYToWorld: position distance: distance
]

{ #category : #'as yet unclassified' }
WDELevelEditorViewMode >> cameraXZDeltaToWorld: delta [
	^ self view cameraXZDeltaToWorld: delta
]

{ #category : #'as yet unclassified' }
WDELevelEditorViewMode >> cameraXZDeltaToWorld: delta distance: screenDistance [
	^ self view cameraXZDeltaToWorld: delta distance: screenDistance
]

{ #category : #accessing }
WDELevelEditorViewMode >> engine [
	^ view engine
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
WDELevelEditorViewMode >> scene [
	^ self model scene
]

{ #category : #'as yet unclassified' }
WDELevelEditorViewMode >> snapToSubGrid: vector [
	^ view snapToSubGrid: vector
]

{ #category : #accessing }
WDELevelEditorViewMode >> view [
	^ view
]

{ #category : #accessing }
WDELevelEditorViewMode >> view: anObject [
	view := anObject
]
