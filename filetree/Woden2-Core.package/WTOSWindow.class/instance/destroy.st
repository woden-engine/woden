factory
destroy
	self terminateDrawingProcess.
	
	"This function must be called when the window is closed"
	application ifNotNil: [ application windowDestroyed: self ].
	
	window eventHandler: nil.
	window destroy.