wrappers
usePipelineState: pipeline
	| result |
	result := AGPUCBindings usePipelineState_command_list: (self validHandle) pipeline: (self validHandleOf: pipeline).
	self checkErrorCode: result
