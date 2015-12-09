wrappers
addReference
	| result |
	result := AGPUCBindings addReference_buffer: (self validHandle).
	self checkErrorCode: result
