state binding
bindResources
	| signature |
	resourceBinding ifNil: [ 
		signature := WDCForwardRenderingShaderSignature for: engine.
		resourceBinding := signature newMaterialState.
	].
	skyTexture ifNotNil: [ resourceBinding bindTexture: 2 texture: skyTexture startMiplevel: 0 miplevels: -1 lodclamp: 100000.0 ].