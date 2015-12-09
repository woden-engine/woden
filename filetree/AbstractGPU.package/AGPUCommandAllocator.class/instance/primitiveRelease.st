wrappers
primitiveRelease
	| result |
	result := AGPUCBindings release_command_allocator: (self validHandle).
	self checkErrorCode: result
