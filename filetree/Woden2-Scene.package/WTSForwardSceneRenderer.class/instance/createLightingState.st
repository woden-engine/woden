initialization
createLightingState
	globalLightingStatePool := WTStreamingUniformBufferPool engine: engine elementType: WTGlobalLightingState.
	globalLightingStatePool heapSize: engine frameBufferingCount * maxNumberOfCameras.
	
	globalLightingStates := engine frameBufferingCollect: [ :frame |
		globalLightingStatePool allocate: maxNumberOfCameras
	].

	globalLightingStateBindings := globalLightingStates collect: [ :states |
		states collect: [ :state |
			(engine createShaderSignature: shaderSignature resourceBinding: 2)
				bind: 0 uniformBufferElement: state;
				yourself
		]
	].

"	| globalLightingStateSize cameraStride frameStride baseOffset |
	globalLightingStateSize := WTGlobalLightingState structureSize alignedTo: 256.
	globalLightingStateBuffer := engine createStreamingUniformBuffer: globalLightingStateSize * engine frameBufferingCount * maxNumberOfCameras.
	
	cameraStride := globalLightingStateSize * engine frameBufferingCount.	
	frameStride := globalLightingStateSize.
		
	globalLightingStateBindings := engine frameBufferingCollect: [ :frame |
		(0 to: maxNumberOfCameras - 1) collect: [ :i |
			baseOffset := (i * cameraStride) + ((frame - 1) * frameStride).
			(engine createShaderSignature: shaderSignature resourceBinding: 2)
				bind: 0 uniformBuffer: globalLightingStateBuffer offset: baseOffset size: globalLightingStateSize;
				yourself
		]
	]."