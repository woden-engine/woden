event handling
onDragEndEvent: anEvent
	toolController ifNotNil: [ toolController onDragEndEvent: anEvent ].
	editor releaseMouse