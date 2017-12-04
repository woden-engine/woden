commands
shaderSignature: shaderSignatureClassOrInstance
	| shaderSignature |
	shaderSignature := shaderSignatureClassOrInstance shaderSignatureFor: engine.
	pipelineStateDescription shaderSignature: shaderSignature.
	commandListBuilder setShaderSignature: shaderSignature handle