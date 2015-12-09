wrappers
addReference
	| result |
	result := AGPUCBindings addReference_shader_resource_binding: (self validHandle).
	self checkErrorCode: result
