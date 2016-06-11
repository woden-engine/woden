visiting
visitMouseMoveEvent: anEvent
	wodenWindow application ifNotNil: [ anEvent accept: wodenWindow application ]