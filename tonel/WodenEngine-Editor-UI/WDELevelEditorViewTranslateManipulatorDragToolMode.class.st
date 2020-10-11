Class {
	#name : #WDELevelEditorViewTranslateManipulatorDragToolMode,
	#superclass : #WDELevelEditorViewManipulatorDragToolMode,
	#category : #'WodenEngine-Editor-UI'
}

{ #category : #'event handling' }
WDELevelEditorViewTranslateManipulatorDragToolMode >> onMouseMove: event [
	| mouseDelta worldDelta |
	mouseDelta := event position - dragStartPosition.
	
	worldDelta := event modifiers ctrl ifTrue: [
		self cameraXZDeltaToWorld: mouseDelta
	] ifFalse: [
		self cameraXYDeltaToWorld: mouseDelta
	].

	manipulator
		restoreMementoForDragging: memento;
		applyTransformForTranslationDelta: worldDelta.
]
