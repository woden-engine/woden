state binding
fetchPipelines
	| psm modeSuffix |
	psm := engine pipelineStateCache.
	modeSuffix := #'color'.
	albedoTexture ifNotNil: [ 
		modeSuffix := #'albedo-texture'
	].

	modePipelines := IdentityDictionary newFromPairs: {
		#forward . psm pipelineStateNamed: (#'material.forward.surface.' , modeSuffix) asSymbol
	}