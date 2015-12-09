wrappers
createPipelineBuilder
	| result |
	result := AGPUCBindings createPipelineBuilder_device: (self validHandle).
	^ AGPUPipelineBuilder forHandle: result
