event handling
visitMouseMoveEvent: event
	dragElement ifNotNil: [ self onMouseDrag: event ]
		ifNil: [ self onMouseOverElements: event ]