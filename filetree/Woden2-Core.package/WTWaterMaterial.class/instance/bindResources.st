state binding
bindResources
	| signature |
	resourceBinding ifNil: [ 
		signature := engine pipelineStateCache shaderSignatureNamed: #ForwardRenderer.
		resourceBinding := engine createShaderSignature: signature resourceBinding: 3.
	].
	stateUniformBuffer ifNil: [
		stateUniformBuffer := engine createStreamingUniformBuffer: (materialState class structureSize alignedTo: 256).
		self uploadMaterialStateData.
	].

	resourceBinding bind: 0 uniformBuffer: stateUniformBuffer.
	normalTexture ifNotNil: [ resourceBinding bindTexture: 2 texture: normalTexture startMiplevel: 0 miplevels: -1 lodclamp: 100000.0 ].
	skyTexture ifNotNil: [ resourceBinding bindTexture: 3 texture: skyTexture startMiplevel: 0 miplevels: -1 lodclamp: 100000.0 ].
		