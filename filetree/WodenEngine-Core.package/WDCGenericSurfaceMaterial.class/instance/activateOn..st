rendering
activateOn: stateTracker
	self validateCache.
	
	stateTracker
		vertexShader: vertexShader;
		fragmentShader: fragmentShader.
	
	resourceBinding ifNotNil: [ 
		stateTracker useShaderResources: resourceBinding.
	].
	
	^ true