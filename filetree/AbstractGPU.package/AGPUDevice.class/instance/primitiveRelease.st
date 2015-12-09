wrappers
primitiveRelease
	| result |
	result := AGPUCBindings release_device: (self validHandle).
	self checkErrorCode: result
