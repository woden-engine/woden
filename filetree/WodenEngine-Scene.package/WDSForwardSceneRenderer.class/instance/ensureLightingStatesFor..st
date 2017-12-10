rendering
ensureLightingStatesFor: requiredNumberOfCameras
	| pool currentNumberOfCameras missingNumberOfCameras |
	globalLightingStates ifNil: [ 
		globalLightingStates := engine frameBufferingCollect: [ :f | #() ].
	].

	pool := engine resourceCache streamingUniformBufferPoolFor: WTGlobalLightingState.
	
	currentNumberOfCameras := globalLightingStates first size.
	missingNumberOfCameras := requiredNumberOfCameras - currentNumberOfCameras.
	
	globalLightingStates := globalLightingStates collect: [ :oldLightingStates |
		oldLightingStates , ((pool allocate: missingNumberOfCameras) collect: [ :bufferElement |
			self shaderSignature newLightingState
				bind: 0 uniformBufferElement: bufferElement;
				bind: 1 texture: self shadowMapBuffer startMiplevel: 0 miplevels: -1 lodclamp: 100000;
				yourself
		])
	].