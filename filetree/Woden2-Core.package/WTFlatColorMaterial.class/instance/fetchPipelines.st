state binding
fetchPipelines
	| psm prefix baseName |
	psm := engine pipelineStateCache.
	baseName := stipple ifTrue: [ 'flat-color-stipple' ] ifFalse: [ 'flat-color' ].
	prefix := baseName , (useDepth
		ifTrue: [ writeDepth ifTrue: [ '.' ] ifFalse: [ '.depth-nowrite.' ] ]
		ifFalse: [ '.no-depth.' ]).
		
	modePipelines := Dictionary newFromPairs: {
		#'forward.lines' . psm pipelineStateNamed: ('material.forward.' , prefix , 'lines') asSymbol.
		#'forward.triangles' . psm pipelineStateNamed: ('material.forward.' , prefix , 'triangles') asSymbol.
	}