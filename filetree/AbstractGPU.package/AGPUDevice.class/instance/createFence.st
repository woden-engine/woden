wrappers
createFence
	| result |
	result := AGPUCBindings createFence_device: (self validHandle).
	^ AGPUFence forHandle: result
