state binding
bindResources
	| signature |
	resourceBinding ifNil: [ 
		signature := WDCForwardRenderingShaderSignature for: engine.
		resourceBinding := signature newMaterialState.
	].

	stateUniformBuffer ifNil: [
		self flag: 'Use a memory pool here.'.
		stateUniformBuffer := engine createStreamingUniformBuffer: (WTGenericSurfaceMaterialState structureSize alignedTo: 256).
		self uploadMaterialStateData.
	].

	resourceBinding bind: 0 uniformBuffer: stateUniformBuffer.
	albedoTexture ifNotNil: [ resourceBinding bindTexture: 2 texture: albedoTexture startMiplevel: 0 miplevels: -1 lodclamp: 100000.0 ].
	normalTexture ifNotNil: [ resourceBinding bindTexture: 3 texture: normalTexture startMiplevel: 0 miplevels: -1 lodclamp: 100000.0 ].
	fresnelTexture ifNotNil: [ resourceBinding bindTexture: 4 texture: fresnelTexture startMiplevel: 0 miplevels: -1 lodclamp: 100000.0 ].