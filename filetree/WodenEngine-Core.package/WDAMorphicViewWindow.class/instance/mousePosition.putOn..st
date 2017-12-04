event handling
mousePosition: anEvent putOn: osEvent
	osEvent position: anEvent position - self bounds origin.
	lastMousePosition := osEvent position.