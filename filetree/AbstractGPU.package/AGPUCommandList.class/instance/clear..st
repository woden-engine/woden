wrappers
clear: buffers
	| result |
	result := AGPUCBindings clear_command_list: (self validHandle) buffers: buffers.
	self checkErrorCode: result
