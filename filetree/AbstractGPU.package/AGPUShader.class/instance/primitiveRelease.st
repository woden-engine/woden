wrappers
primitiveRelease
	| result |
	result := AGPUCBindings release_shader: (self validHandle).
	self checkErrorCode: result
