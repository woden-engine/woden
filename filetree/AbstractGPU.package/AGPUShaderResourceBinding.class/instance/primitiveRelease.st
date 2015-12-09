wrappers
primitiveRelease
	| result |
	result := AGPUCBindings release_shader_resource_binding: (self validHandle).
	self checkErrorCode: result
