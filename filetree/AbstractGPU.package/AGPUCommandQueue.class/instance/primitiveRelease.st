wrappers
primitiveRelease
	| result |
	result := AGPUCBindings release_command_queue: (self validHandle).
	self checkErrorCode: result
