event handling
onDragStartEvent: anEvent
	lastDragPosition := dragStartPosition := anEvent position.
	editor captureMouse.