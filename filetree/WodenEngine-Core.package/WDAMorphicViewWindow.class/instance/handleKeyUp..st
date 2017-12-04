event handling
handleKeyUp: evt
	| event |
	view ifNotNil: [
		event := OSKeyUpEvent new.
		event repeat: 0.
		event symbol: (self keySymbolFor: evt keyValue).
		self mousePosition: evt putOn: event.
		self modifiers: evt putOn: event.
		view handleEvent: event
	]