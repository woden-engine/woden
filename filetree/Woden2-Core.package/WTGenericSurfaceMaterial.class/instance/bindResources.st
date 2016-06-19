state binding
bindResources
	| signature |
	resourceBinding ifNil: [ 
		signature := engine pipelineStateCache shaderSignatureNamed: #ForwardRenderer.
		resourceBinding := engine createShaderSignature: signature resourceBinding: 3.
	].
	stateUniformBuffer ifNil: [
		stateUniformBuffer := engine createStreamingUniformBuffer: (WTGenericSurfaceMaterialState structureSize alignedTo: 256).
		self uploadMaterialStateData.
	].

	resourceBinding bind: 0 uniformBuffer: stateUniformBuffer.
	albedoTexture ifNotNil: [ resourceBinding bindTexture: 2 texture: albedoTexture startMiplevel: 0 miplevels: -1 lodclamp: 100000.0 ].
	normalTexture ifNotNil: [ resourceBinding bindTexture: 3 texture: albedoTexture startMiplevel: 0 miplevels: -1 lodclamp: 100000.0 ].