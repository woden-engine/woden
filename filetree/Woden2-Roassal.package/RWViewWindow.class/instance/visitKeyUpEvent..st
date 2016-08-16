event handling
visitKeyUpEvent: event
	| r3Event |
	r3Event := RWKeyUp new symbol: event symbol.
	view announce: r3Event.
	view signalUpdate