state binding
fetchPipelines
	| psm modeSuffix |
	psm := engine pipelineStateCache.
	modeSuffix := #'color'.
	skyTexture ifNotNil: [
		modeSuffix := #'sky'.
	].
	
	modePipelines := IdentityDictionary newFromPairs: {
		#forward . psm pipelineStateNamed: (#'material.forward.water.' , modeSuffix) asSymbol
	}