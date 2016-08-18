event handling
onDragStartEvent: anEvent
	| element |
	toolController ifNil: [
		anEvent isPrimaryButtonDrag ifTrue: [
			element := (self findBestElementAtGlobalCoord: anEvent position) value asNodeModelForLevelEditor: editor.
			element ifNil: [
				editor isFaceSelectMode ifFalse: [
					self startDragController: WTGEDragMakeSelectionBox new event: anEvent.
				]
			] ifNotNil: [
				self startDragController: (element view: self dragControllerFor: anEvent) event: anEvent.
			]
		].

		anEvent isSecondaryButtonDrag ifTrue: [
			self startDragController: WTGEDragCameraTranslate new event: anEvent.
		].

		anEvent isMiddleButtonDrag ifTrue: [
			self startDragController: WTGEDragCameraRotate new event: anEvent.
		].
	].

	toolController ifNotNil: [ toolController onDragStartEvent: anEvent ].
	editor captureMouse.