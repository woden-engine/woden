wrappers
primitiveRelease
	| result |
	result := AGPUCBindings release_command_list: (self validHandle).
	self checkErrorCode: result
