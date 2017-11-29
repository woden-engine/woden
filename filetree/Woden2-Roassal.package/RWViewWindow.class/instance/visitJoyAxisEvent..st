event handling
visitJoyAxisEvent: event
	| r3Event |
	event isPreferredEvent ifFalse: [ ^ self ].
	r3Event := RWJoyAxis new.
	r3Event which: event which;
		axis: event axis;
		value: event value.
	view announce: r3Event.
