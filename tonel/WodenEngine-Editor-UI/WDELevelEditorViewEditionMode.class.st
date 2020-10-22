Class {
	#name : #WDELevelEditorViewEditionMode,
	#superclass : #WDELevelEditorViewMode,
	#category : #'WodenEngine-Editor-UI-ViewMode'
}

{ #category : #'event handling' }
WDELevelEditorViewEditionMode >> onKeyDown: event [
	self supportsManipulators ifTrue: [ 
		event symbol = OSK_RETURN ifTrue: [ 
			self model activeToolManipulator ifNotNil: [ :manip |
				manip activateAction
			]
		].
	].

	self flag: 'TODO: get rid of this harding ifs.'.
	event modifiers ctrl ifTrue: [ 
		event symbol = OSK_d ifTrue: [ self levelEditorSession deleteSelectedItems ].
		event modifiers shift ifTrue: [ 
			event symbol = OSK_z ifTrue: [ self levelEditorSession redo ].
		] ifFalse: [ 
			event symbol = OSK_z ifTrue: [ self levelEditorSession undo ].
		].
	] ifFalse: [ 
		event symbol = OSK_KP_7 ifTrue: [ self view topView ].
		event symbol = OSK_KP_1 ifTrue: [ self view frontView ].
		event symbol = OSK_KP_5 ifTrue: [ self view togglePerspective ].
		event symbol = OSK_KP_3 ifTrue: [ self view sideView ].
		event symbol = OSK_DELETE ifTrue: [ self levelEditorSession deleteSelectedItems ].
	].

	^ super onKeyDown: event
]

{ #category : #'event handling' }
WDELevelEditorViewEditionMode >> onMouseButtonPress: event [
	event button = 1 ifTrue: [ ^ self selectPointedElementOrStartSelectionDraggingWith: event ].
	event button = 2 ifTrue: [ ^ self startCameraRotateDraggingWith: event ].
	event button = 3 ifTrue: [ ^ self startCameraDraggingWith: event ].
]

{ #category : #'event handling' }
WDELevelEditorViewEditionMode >> onMouseMove: event [
	| elementBeingPointed manipulatorBeingPointed |
	manipulatorBeingPointed := self supportsManipulators
		ifTrue: [view manipulatorInScreenPosition: event position]
		ifFalse: [nil].

	manipulatorBeingPointed ifNotNil: [ 
		self model
			highlightManipulator: manipulatorBeingPointed;
			highlightElement: nil
	] ifNil: [ 
		elementBeingPointed := self supportsElementSelection
			ifTrue: [view elementInScreenPosition: event position]
			ifFalse: [nil].
		self model
			highlightElement: elementBeingPointed;
			highlightManipulator: nil
	].

	^ super onMouseMove: event
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

{ #category : #'as yet unclassified' }
WDELevelEditorViewEditionMode >> supportsElementSelection [
	^ false
]

{ #category : #'as yet unclassified' }
WDELevelEditorViewEditionMode >> supportsManipulators [
	^ false
]
