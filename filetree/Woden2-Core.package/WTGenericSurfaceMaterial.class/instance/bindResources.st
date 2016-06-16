state binding
bindResources
	| signature |
	resourceBinding ifNil: [ 
		signature := engine pipelineStateCache shaderSignatureNamed: #ForwardRenderer.
		resourceBinding := engine createShaderSignature: signature resourceBinding: 3.
	].
	
	albedoTexture ifNotNil: [ resourceBinding bindTexture: 0 texture: albedoTexture startMiplevel: 0 miplevels: -1 lodclamp: 100000.0 ].
	normalTexture ifNotNil: [ resourceBinding bindTexture: 1 texture: albedoTexture startMiplevel: 0 miplevels: -1 lodclamp: 100000.0 ].