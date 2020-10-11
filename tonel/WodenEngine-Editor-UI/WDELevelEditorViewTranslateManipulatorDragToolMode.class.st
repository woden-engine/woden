Class {
	#name : #WDELevelEditorViewTranslateManipulatorDragToolMode,
	#superclass : #WDELevelEditorViewManipulatorDragToolMode,
	#category : #'WodenEngine-Editor-UI-ViewMode'
}

{ #category : #'event handling' }
WDELevelEditorViewTranslateManipulatorDragToolMode >> onMouseMove: event [
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
