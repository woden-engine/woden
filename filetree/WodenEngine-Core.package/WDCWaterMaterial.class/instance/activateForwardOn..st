rendering
activateForwardOn: stateTracker
	self validateCache.
	resourceBinding ifNotNil: [ 
		stateTracker useShaderResources: resourceBinding.
	].
	
	stateTracker
		vertexShader: vertexShader;
		fragmentShader: fragmentShader;
		materialBlendingMode: WDCBlendingMode alphaOver.
	^ true