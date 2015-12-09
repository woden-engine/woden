wrappers
addReference
	| result |
	result := AGPUCBindings addReference_shader_signature: (self validHandle).
	self checkErrorCode: result
