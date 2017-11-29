visiting
visitWindowCloseEvent: anEvent
	anEvent suppressDefaultAction.
	wodenWindow destroy.
	handledHere := true.