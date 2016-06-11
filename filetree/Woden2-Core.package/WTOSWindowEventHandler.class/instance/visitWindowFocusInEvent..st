visiting
visitWindowFocusInEvent: anEvent
	wodenWindow application ifNotNil: [ anEvent accept: wodenWindow application ]