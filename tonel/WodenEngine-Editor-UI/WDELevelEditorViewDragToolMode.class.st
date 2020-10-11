Class {
	#name : #WDELevelEditorViewDragToolMode,
	#superclass : #WDELevelEditorViewMode,
	#instVars : [
		'dragStartButton',
		'dragStartPosition',
		'dragEndPosition'
	],
	#category : #'WodenEngine-Editor-UI'
}

{ #category : #'as yet unclassified' }
WDELevelEditorViewDragToolMode >> cameraXYDeltaToWorld: delta [
	^ (self view cameraXYDeltaToWorld: (self convertMouseDeltaToCamera: delta)) * 0.01
]

{ #category : #'as yet unclassified' }
WDELevelEditorViewDragToolMode >> cameraXZDeltaToWorld: delta [
	^ (self view cameraXZDeltaToWorld: (self convertMouseDeltaToCamera: delta)) * 0.01
]

{ #category : #'as yet unclassified' }
WDELevelEditorViewDragToolMode >> convertMouseDeltaToCamera: delta [
	^ Float32x2 x: delta x y: delta y negated
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
