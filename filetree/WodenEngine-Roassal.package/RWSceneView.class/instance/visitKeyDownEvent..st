visiting
visitKeyDownEvent: event
	| r3Event |
	r3Event := RWKeyDown new symbol: event symbol.
	model announce: r3Event.
	model signalUpdate
