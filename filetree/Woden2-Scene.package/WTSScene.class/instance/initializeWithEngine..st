accessing
initializeWithEngine: anEngine
	engine := anEngine.
	shaderSignature := engine pipelineStateManager shaderSignatureNamed: #ForwardRenderer.