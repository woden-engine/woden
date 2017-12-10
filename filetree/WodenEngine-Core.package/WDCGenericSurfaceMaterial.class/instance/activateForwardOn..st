rendering
activateForwardOn: stateTracker
	self validateCache.
	
	stateTracker
		vertexShader: vertexShader;
		fragmentShader: fragmentShader.
	
	resourceBinding ifNotNil: [ 
		stateTracker useShaderResources: resourceBinding.
	].
	
	^ true