wrappers
reset: allocator initial_pipeline_state: initial_pipeline_state
	| result |
	result := AGPUCBindings reset_command_list: (self validHandle) allocator: (self validHandleOf: allocator) initial_pipeline_state: (self validHandleOf: initial_pipeline_state).
	self checkErrorCode: result
