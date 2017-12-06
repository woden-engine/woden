visiting
visitKeyUpEvent: event
	| r3Event |
	r3Event := RWKeyUp new symbol: event symbol.
	model announce: r3Event.
	model signalUpdate