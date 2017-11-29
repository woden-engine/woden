initialization
initializeWithEngine: anEngine
	engine := anEngine.
	shaderSignature := engine pipelineStateCache shaderSignatureNamed: #ForwardRenderer.
	visibleObjects := OrderedCollection new.
	visibleLightSources := OrderedCollection new.
	
	lightSources := SLVMNativeArray for: WTLightSourceData new: 16.
	
	self
		createRenderPass;
		createCameraStateBuffer;
		createLightingState;
		createSamplers.
