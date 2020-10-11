Class {
	#name : #WDELevelEditorRectangleSelectionDragToolMode,
	#superclass : #WDELevelEditorViewDragToolMode,
	#category : #'WodenEngine-Editor-UI-ViewMode'
}

{ #category : #'events-processing' }
WDELevelEditorRectangleSelectionDragToolMode >> finishDraggingWith: event [
	| elements |
	super finishDraggingWith: event.
	elements := ((dragStartPosition closeTo: dragEndPosition) ifTrue: [ 
		(view elementInScreenPosition: dragEndPosition) ifNil: [#()] ifNotNil: [ :e | { e } ]
	] ifFalse: [ 
		view elementsInScreenRectangle: (dragStartPosition corner: dragEndPosition)
	]).

	event modifiers shift ifTrue: [
		^ view addElementsToSelection: elements
	].
	event modifiers ctrl ifTrue: [ 
		^ view toggleElementsFromSelection: elements
	].
	^ view setSelectedElements: elements
]

{ #category : #'event handling' }
WDELevelEditorRectangleSelectionDragToolMode >> onMouseMove: event [
	super onMouseMove: event.
	view dragToolScreenOverlay: (WDELevelEditorDragRectangleOverlay new
		color: Color blue muchLighter;
		rectangle: (dragStartPosition corner: event position);
		yourself)
]
