Class {
	#name : #WDELevelEditorViewPlacementMode,
	#superclass : #WDELevelEditorViewEditionMode,
	#category : #'WodenEngine-Editor-UI-ViewMode'
}

{ #category : #'event handling' }
WDELevelEditorViewPlacementMode >> startActionDraggingWith: event [
	self levelEditorSession activeSectorLayer ifNotNil: [ 
		view activeToolMode: ((WDELevelEditorBrushDrawDragToolMode for: view)
			dragStartedWith: event;
			yourself)
	].

]

{ #category : #'as yet unclassified' }
WDELevelEditorViewPlacementMode >> supportsManipulators [
	^ true
]
