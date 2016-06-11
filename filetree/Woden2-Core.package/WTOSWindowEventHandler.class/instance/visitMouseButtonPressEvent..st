visiting
visitMouseButtonPressEvent: anEvent
	wodenWindow application ifNotNil: [ anEvent accept: wodenWindow application ]