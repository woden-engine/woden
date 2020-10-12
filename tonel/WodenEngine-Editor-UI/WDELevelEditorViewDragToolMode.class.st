Class {
	#name : #WDELevelEditorViewDragToolMode,
	#superclass : #WDELevelEditorViewMode,
	#instVars : [
		'dragStartButton',
		'dragStartPosition',
		'dragEndPosition'
	],
	#category : #'WodenEngine-Editor-UI-ViewMode'
}

{ #category : #'as yet unclassified' }
WDELevelEditorViewDragToolMode >> cameraXYDeltaToWorld: delta [
	^ self view cameraXYDeltaToWorld: delta
]

{ #category : #'as yet unclassified' }
WDELevelEditorViewDragToolMode >> cameraXYDeltaToWorld: delta distance: screenDistance [
	^ self view cameraXYDeltaToWorld: delta distance: screenDistance
]

{ #category : #'as yet unclassified' }
WDELevelEditorViewDragToolMode >> cameraXYToWorld: position distance: distance [
	^ self view cameraXYToWorld: position distance: distance
]

{ #category : #'as yet unclassified' }
WDELevelEditorViewDragToolMode >> cameraXZDeltaToWorld: delta [
	^ self view cameraXZDeltaToWorld: delta
]

{ #category : #'as yet unclassified' }
WDELevelEditorViewDragToolMode >> cameraXZDeltaToWorld: delta distance: screenDistance [
	^ self view cameraXZDeltaToWorld: delta distance: screenDistance
]

{ #category : #'as yet unclassified' }
WDELevelEditorViewDragToolMode >> dragStartedWith: startEvent [
	dragStartButton := startEvent button.
	dragStartPosition := startEvent position.
]

{ #category : #'events-processing' }
WDELevelEditorViewDragToolMode >> finishDraggingWith: event [
	dragEndPosition := event position.
	self view
		dragToolScreenOverlay: nil;
		activeToolMode: nil
]

{ #category : #'event handling' }
WDELevelEditorViewDragToolMode >> onMouseButtonRelease: event [
	event button = dragStartButton ifTrue: [ self finishDraggingWith: event ].
]

{ #category : #'as yet unclassified' }
WDELevelEditorViewDragToolMode >> snapToSubGrid: vector [
	^ view snapToSubGrid: vector
]
