visiting
visitWindowMouseEnterEvent: anEvent
	wodenWindow application ifNotNil: [ anEvent accept: wodenWindow application ]