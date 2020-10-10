Class {
	#name : #WDELevelEditorViewDragToolMode,
	#superclass : #WDELevelEditorViewMode,
	#instVars : [
		'dragStartButton'
	],
	#category : #'WodenEngine-Editor-UI'
}

{ #category : #'as yet unclassified' }
WDELevelEditorViewDragToolMode >> dragStartedWith: startEvent [
	dragStartButton := startEvent button.
]

{ #category : #'events-processing' }
WDELevelEditorViewDragToolMode >> finishDragging [
	self view activeToolMode: nil
]

{ #category : #'event handling' }
WDELevelEditorViewDragToolMode >> onMouseButtonRelease: event [
	event button = dragStartButton ifTrue: [ self finishDragging ].
]
