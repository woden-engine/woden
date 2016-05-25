initialization
initializeForEngine: anEngine
	engine := anEngine.
	structures := IdentityDictionary new.
	shaderSignatures := IdentityDictionary new.
	vertexLayouts := IdentityDictionary new.
	shaders := IdentityDictionary new.
	pipelineStateObjects :=IdentityDictionary new.
	self
		createSettingsStates;
		loadCoreStates.