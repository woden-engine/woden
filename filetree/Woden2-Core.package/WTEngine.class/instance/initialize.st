initialization
initialize
	super initialize.
	frameIndex := -1.
	bufferingFrameIndex := 1.
	projectionInvertedY := false.
	self initializeForNewSession.
