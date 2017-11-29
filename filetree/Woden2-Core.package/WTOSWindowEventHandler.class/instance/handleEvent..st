visiting
handleEvent: anEvent
	handledHere := false.
	anEvent accept: self.
	handledHere ifTrue: [ ^ self ].
	
	wodenWindow application ifNotNil: [ wodenWindow application handleEvent: anEvent ].