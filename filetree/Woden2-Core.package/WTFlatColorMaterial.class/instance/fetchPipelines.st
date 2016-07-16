state binding
fetchPipelines
	| psm prefix |
	psm := engine pipelineStateCache.
	prefix := useDepth
		ifTrue: [ writeDepth ifTrue: [ 'flat-color.' ] ifFalse: [ 'flat-color.depth-nowrite.' ] ]
		ifFalse: [ 'flat-color.no-depth.' ].
		
	modePipelines := Dictionary newFromPairs: {
		#'forward.lines' . psm pipelineStateNamed: ('material.forward.' , prefix , 'lines') asSymbol.
		#'forward.triangles' . psm pipelineStateNamed: ('material.forward.' , prefix , 'triangles') asSymbol.
	}