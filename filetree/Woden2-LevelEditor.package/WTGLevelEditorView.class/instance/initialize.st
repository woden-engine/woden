initialize-release
initialize
	super initialize.
	gridSize := 1.0.
	self resetCameraState.
	self initializeHandlers.
	self frontView;
		solid;
		perspective