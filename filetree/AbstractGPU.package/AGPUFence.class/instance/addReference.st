wrappers
addReference
	| result |
	result := AGPUCBindings addReference_fence: (self validHandle).
	self checkErrorCode: result
