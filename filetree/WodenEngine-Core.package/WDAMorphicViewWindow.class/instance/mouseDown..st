event handling
mouseDown: evt
	| osEvent |
	
	evt hand newKeyboardFocus: self.
	view ifNotNil: [
		osEvent := OSMouseButtonPressEvent new.
		osEvent button: (self mapMouseButton: (evt whichButton bitAnd: MouseEvent anyButton)).
		self mouseEventCommon: evt putOn: osEvent.
		view handleEvent: osEvent.
	].
	
	evt wasHandled: true.
	^ true.