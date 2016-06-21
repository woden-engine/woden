state binding
fetchPipelines
	| psm |
	psm := engine pipelineStateCache.
	modePipelines := IdentityDictionary newFromPairs: {
		#forward . psm pipelineStateNamed: #'material.forward.sky'.
	}