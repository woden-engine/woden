visiting
visitJoyDeviceRemovedEvent: anEvent
	wodenWindow application ifNotNil: [ anEvent accept: wodenWindow application ]