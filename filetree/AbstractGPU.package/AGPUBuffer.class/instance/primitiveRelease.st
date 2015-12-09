wrappers
primitiveRelease
	| result |
	result := AGPUCBindings release_buffer: (self validHandle).
	self checkErrorCode: result
