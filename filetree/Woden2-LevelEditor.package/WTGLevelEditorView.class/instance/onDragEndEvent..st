event handling
onDragEndEvent: anEvent
	lastDragEndPosition := anEvent position.
	toolController ifNotNil: [ toolController onDragEndEvent: anEvent ].
	editor releaseMouse