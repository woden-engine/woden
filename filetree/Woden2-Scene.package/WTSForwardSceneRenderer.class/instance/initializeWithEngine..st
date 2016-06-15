initialization
initializeWithEngine: anEngine
	engine := anEngine.
	shaderSignature := engine pipelineStateManager shaderSignatureNamed: #ForwardRenderer.
	visibleObjects := OrderedCollection new.
	visibleLightSources := OrderedCollection new.
	
	lightSources := NativeArray for: WTLightSourceData new: 16.
	
	self
		createRenderPass;
		createCommandLists;
		createCameraStateBuffer;
		createLightingState.
