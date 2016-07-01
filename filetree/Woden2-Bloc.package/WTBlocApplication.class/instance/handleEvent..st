as yet unclassified
handleEvent: anEvent
	| eventHandler |
	eventHandler := self findEventHandlerFor: anEvent.
	eventHandler == self
		ifTrue: [ ^ anEvent accept: self ]
		ifFalse: [ eventHandler handleEvent: anEvent. ]
	