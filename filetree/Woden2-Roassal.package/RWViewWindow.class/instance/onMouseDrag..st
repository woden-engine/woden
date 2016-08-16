event handling
onMouseDrag: event
	| r3Event |
	r3Event := RWMouseDrag new buttons: event buttons;
		position: (WDVector2 fromPoint: event position);
		delta: (WDVector2 fromPoint: event delta);
		"element: dragElement."
		element: view.
	r3Event sendToElement.
	view signalUpdate
