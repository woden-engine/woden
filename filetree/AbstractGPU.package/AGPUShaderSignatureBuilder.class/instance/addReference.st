wrappers
addReference
	| result |
	result := AGPUCBindings addReference_shader_signature_builder: (self validHandle).
	self checkErrorCode: result
