wrappers
addReference
	| result |
	result := AGPUCBindings addReference_command_queue: (self validHandle).
	self checkErrorCode: result
