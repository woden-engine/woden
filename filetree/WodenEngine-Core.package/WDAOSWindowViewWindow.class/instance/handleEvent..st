event processing
handleEvent: anEvent
	super handleEvent: anEvent.
	handledHere ifTrue: [ ^ self ].
	
	view ifNotNil: [ view handleEvent: anEvent ]