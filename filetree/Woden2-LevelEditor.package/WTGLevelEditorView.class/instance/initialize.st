initialize-release
initialize
	super initialize.
	viewScale := 3.0.
	self resetCameraState.
	self initializeHandlers.
	self frontView;
		solid;
		perspective