event handling
onMouseButtonDown: event
	event button = 1 ifTrue: [
		self shoot
	]