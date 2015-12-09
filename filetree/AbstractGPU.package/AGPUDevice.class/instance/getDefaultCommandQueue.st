wrappers
getDefaultCommandQueue
	| result |
	result := AGPUCBindings getDefaultCommandQueue_device: (self validHandle).
	^ AGPUCommandQueue forHandle: result
