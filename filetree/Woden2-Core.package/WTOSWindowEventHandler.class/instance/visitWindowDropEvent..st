visiting
visitWindowDropEvent: anEvent
	wodenWindow application ifNotNil: [ anEvent accept: wodenWindow application ]