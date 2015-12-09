wrappers
createCommandListBundle: allocator initial_pipeline_state: initial_pipeline_state
	| result |
	result := AGPUCBindings createCommandListBundle_device: (self validHandle) allocator: (self validHandleOf: allocator) initial_pipeline_state: (self validHandleOf: initial_pipeline_state).
	^ AGPUCommandList forHandle: result
