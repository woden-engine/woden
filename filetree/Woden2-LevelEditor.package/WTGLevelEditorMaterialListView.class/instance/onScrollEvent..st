event handling
onScrollEvent: event
	event direction = Character arrowUp ifTrue: [ 
		verticalScroll := verticalScroll + VerticalScrollAmount.
		self snapScrolling.
	].
	event direction = Character arrowDown ifTrue: [ 
		verticalScroll := verticalScroll - VerticalScrollAmount.
		self snapScrolling.
	].
	self onMouseMoveEvent: event.

