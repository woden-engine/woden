visiting
visitTouchPointerDownEvent: anEvent
	wodenWindow application ifNotNil: [ anEvent accept: wodenWindow application ]