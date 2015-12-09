wrappers
createCommandAllocator
	| result |
	result := AGPUCBindings createCommandAllocator_device: (self validHandle).
	^ AGPUCommandAllocator forHandle: result
