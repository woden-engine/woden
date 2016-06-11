visiting
visitWindowFocusOutEvent: anEvent
	wodenWindow application ifNotNil: [ anEvent accept: wodenWindow application ]