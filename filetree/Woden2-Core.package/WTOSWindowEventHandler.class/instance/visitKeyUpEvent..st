visiting
visitKeyUpEvent: anEvent
	wodenWindow application ifNotNil: [ anEvent accept: wodenWindow application ]