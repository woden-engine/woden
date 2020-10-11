Class {
	#name : #WDELevelEditorViewEditionMode,
	#superclass : #WDELevelEditorViewMode,
	#category : #'WodenEngine-Editor-UI'
}

{ #category : #'event handling' }
WDELevelEditorViewEditionMode >> onMouseButtonPress: event [
	event button = 1 ifTrue: [ ^ self selectPointedElementOrStartSelectionDraggingWith: event ].
	event button = 2 ifTrue: [ ^ self startCameraRotateDraggingWith: event ].
	event button = 3 ifTrue: [ ^ self startCameraDraggingWith: event ].
]

{ #category : #'event handling' }
WDELevelEditorViewEditionMode >> onMouseWheel: event [
	view isPerspective ifTrue: [ 
		view translateCameraBy: (view zDragDirection * event scrollVertical * 0.5)
	] ifFalse: [
		view viewScale: view viewScale *(1.0 - (event scrollVertical*0.1) max:0.1).
	].

]

{ #category : #'event handling' }
WDELevelEditorViewEditionMode >> selectPointedElementOrStartSelectionDraggingWith: event [
	| manipulator |
	manipulator := view manipulatorInScreenPosition: event position.
	manipulator ifNotNil: [
		^ manipulator startDragToolWithEvent: event on: view
	].

	^ self startActionDraggingWith: event
]

{ #category : #'event handling' }
WDELevelEditorViewEditionMode >> startActionDraggingWith: event [
]

{ #category : #'event handling' }
WDELevelEditorViewEditionMode >> startCameraDraggingWith: event [
	view activeToolMode: ((WDELevelEditorViewCameraDragToolMode for: view)
		dragStartedWith: event;
		yourself)
]

{ #category : #'event handling' }
WDELevelEditorViewEditionMode >> startCameraRotateDraggingWith: event [
	view activeToolMode: ((WDELevelEditorViewCameraRotateDragToolMode for: view)
		dragStartedWith: event;
		yourself)
]
