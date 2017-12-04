comparing
= other
	self class == other class ifFalse: [ ^ false ].
	
	vertexShader == other vertexShader ifFalse: [ ^ false ].
	vertexLayout == other vertexLayout ifFalse: [ ^ false ].
	fragmentShader == other fragmentShader ifFalse: [ ^ false ].
	shaderSignature == other shaderSignature ifFalse: [ ^ false ].

	primitiveType = other primitiveType ifFalse: [ ^ false ].
	frontFaceWinding = other frontFaceWinding ifFalse: [ ^ false ].
	cullMode = other cullMode ifFalse: [ ^ false ].

	depthEnabled = other depthEnabled ifFalse: [ ^ false ].
	depthWriteMask = other depthWriteMask ifFalse: [ ^ false ].
	depthFunction = other depthFunction ifFalse: [ ^ false ].

	renderTargetFormats = other renderTargetFormats ifFalse: [ ^ false ].
	depthStencilFormat = other depthStencilFormat ifFalse: [ ^ false ].
	blendingStates = other blendingStates ifFalse: [ ^ false ].
	sampleCount = other sampleCount ifFalse: [ ^ false ].
	^ true
