wrappers
getCurrentBackBuffer
	| result |
	result := AGPUCBindings getCurrentBackBuffer_swap_chain: (self validHandle).
	^ AGPUFramebuffer forHandle: result
