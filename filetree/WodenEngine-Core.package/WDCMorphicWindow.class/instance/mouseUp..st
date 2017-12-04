event handling
mouseUp: evt
	| osEvent |
	view ifNotNil: [
		osEvent := OSMouseButtonReleaseEvent new.
		osEvent button: (self mapMouseButton: evt whichButton).
		self mouseEventCommon: evt putOn: osEvent.
		view handleEvent: osEvent.
	].

	evt wasHandled: true.
