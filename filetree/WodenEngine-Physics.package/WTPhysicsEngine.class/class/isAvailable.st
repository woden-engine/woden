testing
isAvailable
	self checkAndLoadEngine.
	^ CurrentEngine ~~ nil.