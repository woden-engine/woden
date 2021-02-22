Class {
	#name : #WDELevelEditorViewTranslateManipulatorDragToolMode,
	#superclass : #WDELevelEditorViewManipulatorDragToolMode,
	#category : #'WodenEngine-Editor-UI-ViewMode'
}

{ #category : #'as yet unclassified' }
WDELevelEditorViewTranslateManipulatorDragToolMode >> modeName [
	^ 'Translate'
]

{ #category : #'event handling' }
WDELevelEditorViewTranslateManipulatorDragToolMode >> onMouseDrag: event [
	| mouseDelta worldDelta |
	mouseDelta := event position - dragStartPosition.
	
	worldDelta := event modifiers ctrl ifTrue: [
		self cameraXZDeltaToWorld: mouseDelta distance: dragScreenDistance
	] ifFalse: [
		self cameraXYDeltaToWorld: mouseDelta distance: dragScreenDistance
	].

	manipulator
		restoreMementoForDragging: memento;
		applyTransformForTranslationDelta: (self snapToSubGrid: worldDelta).
]
