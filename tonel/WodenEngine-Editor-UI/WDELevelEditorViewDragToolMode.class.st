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
	event button = dragStartButton ifTrue: [
		self finishDraggingWith: event.
		(event button = 3 and:
		[(dragStartPosition closeTo: dragEndPosition) and:
		[self levelEditorSession selection selectedItems isNotEmpty]]) ifTrue: [
			^ self levelEditorSession buildSelectionContextMenu openWithSpecAt: self currentHand position
		].
	].
]
