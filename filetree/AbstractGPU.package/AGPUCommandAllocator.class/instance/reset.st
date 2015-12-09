wrappers
reset
	| result |
	result := AGPUCBindings reset_command_allocator: (self validHandle).
	self checkErrorCode: result
