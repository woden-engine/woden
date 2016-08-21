event handling
onDragEvent: anEvent
	self updateCameraProjection.
	toolController ifNotNil: [ toolController onDragEvent: anEvent ].