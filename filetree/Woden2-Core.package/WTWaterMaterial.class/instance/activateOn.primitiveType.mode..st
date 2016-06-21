rendering
activateOn: listBuilder primitiveType: primitiveType mode: renderMode
	| pipeline |
	self validateCache.
	resourceBinding ifNotNil: [ 
		listBuilder useShaderResources: resourceBinding validHandle.
	].
	
	pipeline := modePipelines at: renderMode ifAbsent: [ ^ false ].
	listBuilder usePipelineState: pipeline handle.
	^ true