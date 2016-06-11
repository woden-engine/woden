as yet unclassified
engineChanged
	| psm |
	psm := engine pipelineStateManager.
	modePipelines := IdentityDictionary newFromPairs: {
		#forward . psm pipelineStateNamed: #'material.forward.surface.color'
	}