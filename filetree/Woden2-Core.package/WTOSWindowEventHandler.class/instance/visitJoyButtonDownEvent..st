visiting
visitJoyButtonDownEvent: anEvent
	wodenWindow application ifNotNil: [ anEvent accept: wodenWindow application ]