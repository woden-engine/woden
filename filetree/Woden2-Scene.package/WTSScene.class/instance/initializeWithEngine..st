accessing
initializeWithEngine: anEngine
	engine := anEngine.
	shaderSignature := engine pipelineStateCache shaderSignatureNamed: #ForwardRenderer.