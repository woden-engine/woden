state binding
bindResources
	| signature |
	resourceBinding ifNil: [ 
		signature := engine pipelineStateCache shaderSignatureNamed: #ForwardRenderer.
		resourceBinding := engine createShaderSignature: signature resourceBinding: 3.
	].
	skyTexture ifNotNil: [ resourceBinding bindTexture: 2 texture: skyTexture startMiplevel: 0 miplevels: -1 lodclamp: 100000.0 ].