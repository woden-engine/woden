wrappers
primitiveRelease
	| result |
	result := AGPUCBindings release_fence: (self validHandle).
	self checkErrorCode: result
