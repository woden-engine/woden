wrappers
primitiveRelease
	| result |
	result := AGPUCBindings release_shader_signature: (self validHandle).
	self checkErrorCode: result
