event handling
visitKeyDownEvent: event
	| r3Event |
	r3Event := RWKeyDown new symbol: event symbol.
	view announce: r3Event.
	view signalUpdate
