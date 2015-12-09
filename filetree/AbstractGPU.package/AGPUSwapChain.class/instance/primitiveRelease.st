wrappers
primitiveRelease
	| result |
	result := AGPUCBindings release_swap_chain: (self validHandle).
	self checkErrorCode: result
