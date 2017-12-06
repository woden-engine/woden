visiting
onMouseDrag: event
	| r3Event |
	r3Event := RWMouseDrag new buttons: event buttons;
		position: event position asWMVector2F;
		delta: event delta asWMVector2F;
		"element: dragElement."
		element: model.
	r3Event sendToElement.
	model signalUpdate
