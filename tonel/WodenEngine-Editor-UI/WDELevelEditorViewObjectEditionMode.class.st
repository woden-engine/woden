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
WDELevelEditorViewObjectEditionMode >> onMouseMove: event [
	| elementBeingPointed manipulatorBeingPointed |
	manipulatorBeingPointed := view manipulatorInScreenPosition: event position.
	manipulatorBeingPointed ifNotNil: [ 
		self model
			highlightManipulator: manipulatorBeingPointed;
			highlightElement: nil
	] ifNil: [ 
		elementBeingPointed := view elementInScreenPosition: event position.
		self model
			highlightElement: elementBeingPointed;
			highlightManipulator: nil
	].
	^ super onMouseMove: event
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
