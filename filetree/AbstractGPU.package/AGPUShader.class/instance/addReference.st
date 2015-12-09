wrappers
addReference
	| result |
	result := AGPUCBindings addReference_shader: (self validHandle).
	self checkErrorCode: result
