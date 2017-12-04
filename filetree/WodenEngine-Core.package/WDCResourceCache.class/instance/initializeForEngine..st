initialization
initializeForEngine: anEngine
	engine := anEngine.
	resources := WeakValueDictionary new.
	shaderSignatures := IdentityDictionary new.
	vertexLayouts := IdentityDictionary new.
	pipelineStates := Dictionary new.

	shaderLanguageTarget := engine device getPreferredHighLevelShaderLanguage.
	shaderLanguageTarget = AGPU_SHADER_LANGUAGE_NONE ifTrue: [
		shaderLanguageTarget := engine device getPreferredShaderLanguage
	].

	shaderLanguageTargetName := ShaderLanguageTargetMap at: shaderLanguageTarget.