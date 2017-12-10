rendering
activateShadowOn: stateTracker
	self validateCache.
	stateTracker
		vertexShader: vertexShader;
		fragmentShader: nil.
	^ true