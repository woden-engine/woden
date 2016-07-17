rendering
activateOn: listBuilder primitiveType: primitiveType mode: renderMode submode: submode
	| pipeline |
	self validateCache.
	resourceBinding ifNotNil: [ 
		listBuilder useShaderResources: resourceBinding validHandle.
	].
	
	pipeline := modePipelines at: renderMode ifAbsent: [ ^ false ].
	listBuilder usePipelineState: pipeline validHandle.
	^ true