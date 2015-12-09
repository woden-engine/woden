wrappers
primitiveRelease
	| result |
	result := AGPUCBindings release_framebuffer: (self validHandle).
	self checkErrorCode: result
