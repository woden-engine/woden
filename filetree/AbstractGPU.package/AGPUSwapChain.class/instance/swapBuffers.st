wrappers
swapBuffers
	| result |
	result := AGPUCBindings swapBuffers_swap_chain: (self validHandle).
	self checkErrorCode: result
