visiting
visitUnknownEvent: anEvent
	wodenWindow application ifNotNil: [ anEvent accept: wodenWindow application ]