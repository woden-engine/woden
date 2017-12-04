event processing
visitWindowCloseEvent: anEvent
	anEvent suppressDefaultAction.
	self close.
	handledHere := true.