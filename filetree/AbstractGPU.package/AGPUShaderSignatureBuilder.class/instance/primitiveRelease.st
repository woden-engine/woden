wrappers
primitiveRelease
	| result |
	result := AGPUCBindings release_shader_signature_builder: (self validHandle).
	self checkErrorCode: result
