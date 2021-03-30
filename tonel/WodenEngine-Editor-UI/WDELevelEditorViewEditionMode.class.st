Class {
	#name : #WDELevelEditorViewEditionMode,
	#superclass : #WDELevelEditorViewMode,
	#category : #'WodenEngine-Editor-UI-ViewMode'
}

{ #category : #'event handling' }
WDELevelEditorViewEditionMode >> activateAction [
	self model activeToolManipulator ifNotNil: [ :manip |
		manip activateAction
	]

]

{ #category : #'event handling' }
WDELevelEditorViewEditionMode >> cancelAction [
]

{ #category : #'event handling' }
WDELevelEditorViewEditionMode >> onLeftClick: event [
	| elements |
	self supportsElementSelection ifFalse: [ ^ self ].
	elements := (view elementInScreenPosition: event position) ifNil: [ #() ] ifNotNil: [ :e | { e } ].
	event modifiers shift ifTrue: [
		^ view addElementsToSelection: elements
	].
	event modifiers ctrl ifTrue: [ 
		^ view toggleElementsFromSelection: elements
	].

	^ view setSelectedElements: elements
]

{ #category : #'event handling' }
WDELevelEditorViewEditionMode >> onMouseDragStart: event [
	event button = 1 ifTrue: [ ^ self startManipulatorOrActionDraggingWith: event ].
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
WDELevelEditorViewEditionMode >> onRightClick: event [
	| elements |
	self supportsElementSelection ifFalse: [ ^ self ].
	elements := (view elementInScreenPosition: event position) ifNil: [ #() ] ifNotNil: [ :e | { e } ].
	view setSelectedElements: elements.
	elements ifNotEmpty: [ 
		view levelEditorSession buildSelectionContextMenu openWithSpecAtPointer
	].

]

{ #category : #'event handling' }
WDELevelEditorViewEditionMode >> shortcuts [
	^ super shortcuts , {
		KeyboardKey escape asKeyCombination . [ self cancelAction ].
		KeyboardKey enter asKeyCombination . [ self activateAction ].

		$z asKeyCombination . [ view openShadingMenu ].
		$z command mac | $z control unix | $z control win . [ self levelEditorSession undo ].
		$z command shift mac | $z control shift unix | $z control shift win . [ self levelEditorSession redo ].

		$d command mac | $d control unix | $d control win . [ self levelEditorSession duplicateSelectedItems  ].
		$p command mac | $p control unix | $p control win . [ self levelEditorSession playLevel ].

		KeyboardKey delete asKeyCombination . [ self levelEditorSession deleteSelectedItems  ].

		(KeyboardKey named: #KP_7) asKeyCombination . [ self view topView ].
		(KeyboardKey named: #KP_7) command mac | (KeyboardKey named: #KP_7) control unix | (KeyboardKey named: #KP_7) control win . [ self view bottomView ].

		(KeyboardKey named: #KP_1) asKeyCombination . [ self view frontView ].
		(KeyboardKey named: #KP_1) command mac | (KeyboardKey named: #KP_1) control unix | (KeyboardKey named: #KP_1) control win . [ self view backView ].

		(KeyboardKey named: #KP_3) asKeyCombination . [ self view leftView ].
		(KeyboardKey named: #KP_3) command mac | (KeyboardKey named: #KP_3) control unix | (KeyboardKey named: #KP_3) control win . [ self view rightView ].

		(KeyboardKey named: #KP_5) asKeyCombination . [ self view togglePerspective ].
		KeyboardKey delete asKeyCombination . [ self levelEditorSession deleteSelectedItems ].
	}
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

{ #category : #'event handling' }
WDELevelEditorViewEditionMode >> startManipulatorOrActionDraggingWith: event [
	self supportsManipulators ifTrue: [
		| manipulator |
		manipulator := view manipulatorInScreenPosition: event position.
		manipulator ifNotNil: [
			^ manipulator startDragToolWithEvent: event on: view
		].
	].

	^ self startActionDraggingWith: event
]

{ #category : #'as yet unclassified' }
WDELevelEditorViewEditionMode >> supportsElementSelection [
	^ false
]

{ #category : #'as yet unclassified' }
WDELevelEditorViewEditionMode >> supportsManipulators [
	^ false
]
