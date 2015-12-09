wrappers
createCommandList: allocator initial_pipeline_state: initial_pipeline_state
	| result |
	result := AGPUCBindings createCommandList_device: (self validHandle) allocator: (self validHandleOf: allocator) initial_pipeline_state: (self validHandleOf: initial_pipeline_state).
	^ AGPUCommandList forHandle: result
