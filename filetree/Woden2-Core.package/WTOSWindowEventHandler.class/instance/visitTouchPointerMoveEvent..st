visiting
visitTouchPointerMoveEvent: anEvent
	wodenWindow application ifNotNil: [ anEvent accept: wodenWindow application ]