visiting
visitWindowMoveEvent: anEvent
	wodenWindow application ifNotNil: [ anEvent accept: wodenWindow application ]