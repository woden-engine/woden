as yet unclassified
handleEvent: anEvent
	| eventHandler |
	eventHandler := self findEventHandlerFor: anEvent.
	eventHandler ifNil: [ ^ self ].
	eventHandler == self
		ifTrue: [ ^ anEvent accept: self ]
		ifFalse: [ eventHandler handleEvent: anEvent. ]
	