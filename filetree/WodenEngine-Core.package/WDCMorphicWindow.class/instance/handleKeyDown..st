event handling
handleKeyDown: evt
	| event |
	view ifNotNil: [
		event := OSKeyDownEvent new.
		event repeat: 0.
		event symbol: (self keySymbolFor: evt keyValue).
		self mousePosition: evt putOn: event.
		self modifiers: evt putOn: event.
		view handleEvent: event.
	].