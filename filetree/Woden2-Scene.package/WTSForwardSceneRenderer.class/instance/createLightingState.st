initialization
createLightingState
	| globalLightingStateSize |
	globalLightingStateSize := WTGlobalLightingState structureSize alignedTo: 256.
	globalLightingStateBuffer := engine createStreamingUniformBuffer: globalLightingStateSize * engine frameBufferingCount.
	globalLightingStateBindings := engine frameBufferingCollect: [ :frame |
		(engine createShaderSignature: shaderSignature resourceBinding: 2)
			bind: 0 uniformBuffer: globalLightingStateBuffer offset: (frame - 1) * globalLightingStateSize size: globalLightingStateSize;
			yourself
	].