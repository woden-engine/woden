visiting
visitJoyAxisEvent: anEvent
	wodenWindow application ifNotNil: [ anEvent accept: wodenWindow application ]