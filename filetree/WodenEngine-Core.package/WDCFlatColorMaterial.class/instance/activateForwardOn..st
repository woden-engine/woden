rendering
activateForwardOn: stateTracker
	self validateCache.
	stateTracker
		vertexShader: vertexShader;
		fragmentShader: fragmentShader.
	^ true