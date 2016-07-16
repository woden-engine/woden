rendering
activateOn: listBuilder primitiveType: primitiveType mode: renderMode submode: submode
	| pipeline |
	self validateCache.
	pipeline := modePipelines at: (renderMode , (self primitiveTypeToStateSuffix: primitiveType)) ifAbsent: [ ^ false ].
	listBuilder usePipelineState: pipeline handle.
	^ true