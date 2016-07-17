event handling
onDragEvent: anEvent
	toolController ifNotNil: [ toolController onDragEvent: anEvent ].