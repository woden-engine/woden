visiting
visitTouchPointerUpEvent: anEvent
	wodenWindow application ifNotNil: [ anEvent accept: wodenWindow application ]