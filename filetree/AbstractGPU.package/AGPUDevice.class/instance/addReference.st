wrappers
addReference
	| result |
	result := AGPUCBindings addReference_device: (self validHandle).
	self checkErrorCode: result
