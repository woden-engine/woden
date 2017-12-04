pipeline states
buildPipelineStateWithDescription: description
	| handle |
	engine trace: 'Build PSO vertex: {1} fragment {2}.' format: {description vertexShader asString . description fragmentShader asString}.
	handle := description buildForDevice: engine device.
	^ WDCPipelineState new
		description: description copy;
		handle: handle;
		yourself