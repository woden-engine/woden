visiting
visitJoyDeviceAddedEvent: anEvent
	wodenWindow application ifNotNil: [ anEvent accept: wodenWindow application ]