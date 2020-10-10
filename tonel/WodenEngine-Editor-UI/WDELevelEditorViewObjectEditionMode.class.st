Class {
	#name : #WDELevelEditorViewObjectEditionMode,
	#superclass : #WDELevelEditorViewEditionMode,
	#category : #'WodenEngine-Editor-UI'
}

{ #category : #'event handling' }
WDELevelEditorViewObjectEditionMode >> onMouseMove: event [
	| elementBeingPointed |
	elementBeingPointed := view elementInPosition: event position.
	self model highlightElement: elementBeingPointed.
	^ super onMouseMove: event
]
