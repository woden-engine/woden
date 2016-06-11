rendering
activateOn: listBuilder primitiveType: primitiveType mode: renderMode
	| pipeline |
	pipeline := modePipelines at: renderMode ifAbsent: [ ^ false ].
	listBuilder usePipelineState: pipeline handle.
	^ true