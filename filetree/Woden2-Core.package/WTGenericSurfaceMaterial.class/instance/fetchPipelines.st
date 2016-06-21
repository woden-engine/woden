state binding
fetchPipelines
	| psm modeSuffix |
	psm := engine pipelineStateCache.
	modeSuffix := #'color'.
	albedoTexture ifNotNil: [ 
		normalTexture ifNotNil: [
			fresnelTexture ifNotNil: [
				modeSuffix := #'albedo-normal-fresnel-texture' 
			] ifNil: [
				modeSuffix := #'albedo-normal-texture'
			]		
		] ifNil: [
			fresnelTexture ifNotNil: [ 
				modeSuffix := #'albedo-fresnel-texture'.
			] ifNil: [
				modeSuffix := #'albedo-texture'.
			]
		]	
	].

	modePipelines := IdentityDictionary newFromPairs: {
		#forward . psm pipelineStateNamed: (#'material.forward.surface.' , modeSuffix) asSymbol
	}