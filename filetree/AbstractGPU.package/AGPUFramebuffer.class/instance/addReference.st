wrappers
addReference
	| result |
	result := AGPUCBindings addReference_framebuffer: (self validHandle).
	self checkErrorCode: result
