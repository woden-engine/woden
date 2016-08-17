event handling
onKeyDownEvent: event
	| keyValue |
	keyValue := event keyValue.
	
	"TODO: Move the selection element instead of just scrolling."
	keyValue = OSK_DOWN ifTrue: [ 
		verticalScroll := verticalScroll - VerticalScrollAmount.
		self onMouseMoveEvent: event.
	].
	keyValue = OSK_UP ifTrue: [ 
		verticalScroll := verticalScroll + VerticalScrollAmount.
		self snapScrolling.
		self onMouseMoveEvent: event.
	].
