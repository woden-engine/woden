Class {
	#name : #WDELevelEditorRectangleSelectionDragToolMode,
	#superclass : #WDELevelEditorViewDragToolMode,
	#category : #'WodenEngine-Editor-UI-ViewMode'
}

{ #category : #'events-processing' }
WDELevelEditorRectangleSelectionDragToolMode >> finishDraggingWith: event [
	| elements |
	super finishDraggingWith: event.
	elements := view elementsInScreenRectangle: (dragStartPosition corner: dragEndPosition).

	event modifiers shift ifTrue: [
		^ view addElementsToSelection: elements
	].
	event modifiers ctrl ifTrue: [ 
		^ view toggleElementsFromSelection: elements
	].
	^ view setSelectedElements: elements
]

{ #category : #'as yet unclassified' }
WDELevelEditorRectangleSelectionDragToolMode >> modeName [
	^ 'Rectangle selection'
]

{ #category : #'event handling' }
WDELevelEditorRectangleSelectionDragToolMode >> onMouseDrag: event [
	super onMouseDrag: event.
	view dragToolScreenOverlay: (WDELevelEditorDragRectangleOverlay new
		color: Color blue muchLighter;
		rectangle: (dragStartPosition corner: event position);
		yourself)
]
