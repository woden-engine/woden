visiting
visitTextInputEvent: anEvent
	wodenWindow application ifNotNil: [ anEvent accept: wodenWindow application ]