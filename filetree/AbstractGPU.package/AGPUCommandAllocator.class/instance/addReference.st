wrappers
addReference
	| result |
	result := AGPUCBindings addReference_command_allocator: (self validHandle).
	self checkErrorCode: result
