wrappers
setClearDepth: depth
	| result |
	result := AGPUCBindings setClearDepth_command_list: (self validHandle) depth: depth.
	self checkErrorCode: result
