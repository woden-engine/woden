event handling
visitMouseButtonReleaseEvent: event
	| r3Event |
	r3Event := RWMouseButtonUp new buttons: event buttons;
		position: event position asWMVector2F;
		button: event button.
	r3Event element: (self elementInPosition: event position).
	dragElement := nil.
	self sendMouseEvent: r3Event.
	view signalUpdate