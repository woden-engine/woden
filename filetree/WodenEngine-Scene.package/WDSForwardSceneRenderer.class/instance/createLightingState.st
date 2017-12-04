initialization
createLightingState
	globalLightingStatePool := WDCStreamingUniformBufferPool engine: engine elementType: WTGlobalLightingState.
	globalLightingStatePool heapSize: engine frameBufferingCount * self maxNumberOfCameras.
	
	globalLightingStates := engine frameBufferingCollect: [ :frame |
		globalLightingStatePool allocate: self maxNumberOfCameras
	].

	globalLightingStateBindings := globalLightingStates collect: [ :states |
		states collect: [ :state |
			self shaderSignature newLightingState
				bind: 0 uniformBufferElement: state;
				yourself
		]
	].
