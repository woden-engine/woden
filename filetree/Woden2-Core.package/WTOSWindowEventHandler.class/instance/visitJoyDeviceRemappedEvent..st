visiting
visitJoyDeviceRemappedEvent: anEvent
	wodenWindow application ifNotNil: [ anEvent accept: wodenWindow application ]