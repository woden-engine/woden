initialization
initialize
	super initialize.
	frameIndex := -1.
	bufferingFrameIndex := 1.
	projectionInvertedY := false.
	defaultMaterial := WTGenericSurfaceMaterial for: self.
	self initializeForNewSession.
