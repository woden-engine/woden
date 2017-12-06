visiting
visitJoyButtonUpEvent: event
	| r3Event |
	event isPreferredEvent ifFalse: [ ^ self ].
	r3Event := RWJoyButtonUp new.
	r3Event which: event which;
		button: event button.
	model announce: r3Event.
