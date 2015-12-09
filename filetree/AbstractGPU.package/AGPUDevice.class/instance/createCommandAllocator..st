wrappers
createCommandAllocator: type
	| result |
	result := AGPUCBindings createCommandAllocator_device: (self validHandle) type: type.
	^ AGPUCommandAllocator forHandle: result
