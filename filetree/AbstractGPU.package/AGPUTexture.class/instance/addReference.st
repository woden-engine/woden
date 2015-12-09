wrappers
addReference
	| result |
	result := AGPUCBindings addReference_texture: (self validHandle).
	self checkErrorCode: result
