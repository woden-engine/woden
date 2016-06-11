visiting
visitJoyButtonUpEvent: anEvent
	wodenWindow application ifNotNil: [ anEvent accept: wodenWindow application ]