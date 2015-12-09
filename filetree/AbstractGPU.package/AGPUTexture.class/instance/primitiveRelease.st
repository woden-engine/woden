wrappers
primitiveRelease
	| result |
	result := AGPUCBindings release_texture: (self validHandle).
	self checkErrorCode: result
