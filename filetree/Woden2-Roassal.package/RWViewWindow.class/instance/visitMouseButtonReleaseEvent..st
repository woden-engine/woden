event handling
visitMouseButtonReleaseEvent: event
	| r3Event |
	r3Event := RWMouseButtonUp new buttons: event buttons;
		position: (WDVector2 fromPoint: event position);
		button: event button.
	r3Event element: (self elementInPosition: event position).
	dragElement := nil.
	self sendMouseEvent: r3Event.
	view signalUpdate