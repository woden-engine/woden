Class {
	#name : #WDELevelEditorViewObjectEditionMode,
	#superclass : #WDELevelEditorViewEditionMode,
	#category : #'WodenEngine-Editor-UI-ViewMode'
}

{ #category : #'as yet unclassified' }
WDELevelEditorViewObjectEditionMode >> modeName [
	^ 'Object Mode'
]

{ #category : #'event handling' }
WDELevelEditorViewObjectEditionMode >> startActionDraggingWith: event [
	view activeToolMode: ((WDELevelEditorRectangleSelectionDragToolMode for: view)
		dragStartedWith: event;
		yourself)
]

{ #category : #'as yet unclassified' }
WDELevelEditorViewObjectEditionMode >> supportsElementSelection [
	^ true
]

{ #category : #'as yet unclassified' }
WDELevelEditorViewObjectEditionMode >> supportsManipulators [
	^ true
]
