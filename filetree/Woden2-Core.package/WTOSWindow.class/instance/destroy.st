factory
destroy
	drawingProcess terminate.
	
	"This function must be called when the window is closed"
	application ifNotNil: [ application windowDestroyed: self ].
	