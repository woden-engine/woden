pipeline states
buildPipelineStateWithDescription: description
	| handle result |
	engine trace: 'Build PSO vertex: {1} fragment {2}.' format: {description vertexShader asString . description fragmentShader asString}.
	result := WDCPipelineState new
		description: description copy;
		device: engine device;
		yourself.
	result build.
	^ result