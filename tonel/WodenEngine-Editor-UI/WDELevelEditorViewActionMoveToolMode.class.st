Class {
	#name : #WDELevelEditorViewActionMoveToolMode,
	#superclass : #WDELevelEditorViewMode,
	#instVars : [
		'startPosition',
		'endPosition',
		'currentPosition',
		'screenDistance'
	],
	#category : #'WodenEngine-Editor-UI-ViewMode'
}

{ #category : #'as yet unclassified' }
WDELevelEditorViewActionMoveToolMode >> cameraXZDeltaToWorld: delta [
	^ self view cameraXZDeltaToWorld: delta distance: screenDistance
]

{ #category : #'as yet unclassified' }
WDELevelEditorViewActionMoveToolMode >> dragCancelled [
	self view
		activeToolMode: nil
]

{ #category : #'as yet unclassified' }
WDELevelEditorViewActionMoveToolMode >> dragDelta: delta [
]

{ #category : #'as yet unclassified' }
WDELevelEditorViewActionMoveToolMode >> dragFinished [
	self view
		activeToolMode: nil
]

{ #category : #'as yet unclassified' }
WDELevelEditorViewActionMoveToolMode >> dragStarted [
]

{ #category : #initialization }
WDELevelEditorViewActionMoveToolMode >> initialize [
	super initialize.
	screenDistance := 1.0.
]

{ #category : #'event handling' }
WDELevelEditorViewActionMoveToolMode >> onKeyDown: event [
	event symbol = OSK_ESCAPE ifTrue: [ 
		self dragCancelled
	]
]

{ #category : #'event handling' }
WDELevelEditorViewActionMoveToolMode >> onLeftClick: event [
	endPosition := currentPosition := event position.
	self dragFinished
]

{ #category : #'event handling' }
WDELevelEditorViewActionMoveToolMode >> onMouseMove: event [
	currentPosition := event position.
	startPosition ifNil: [
		startPosition := currentPosition.
		self dragStarted.
	] ifNotNil: [
		self dragDelta: currentPosition - startPosition
	]
]

{ #category : #'event handling' }
WDELevelEditorViewActionMoveToolMode >> onRightClick: event [
	self dragCancelled
]

{ #category : #accessing }
WDELevelEditorViewActionMoveToolMode >> view: aView [
	super view: aView.
	screenDistance := aView cameraFocalPointDistance.
]
