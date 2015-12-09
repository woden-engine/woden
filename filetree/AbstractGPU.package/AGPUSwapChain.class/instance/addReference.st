wrappers
addReference
	| result |
	result := AGPUCBindings addReference_swap_chain: (self validHandle).
	self checkErrorCode: result
