Class {
	#name : #WDELevelEditorViewManipulatorDragToolMode,
	#superclass : #WDELevelEditorViewDragToolMode,
	#instVars : [
		'manipulator',
		'memento'
	],
	#category : #'WodenEngine-Editor-UI'
}

{ #category : #'as yet unclassified' }
WDELevelEditorViewManipulatorDragToolMode >> dragStartedWith: startEvent [
	super dragStartedWith: startEvent.
	memento := manipulator mementoForDragging.
]

{ #category : #accessing }
WDELevelEditorViewManipulatorDragToolMode >> manipulator [
	^ manipulator
]

{ #category : #accessing }
WDELevelEditorViewManipulatorDragToolMode >> manipulator: anObject [
	manipulator := anObject
]
