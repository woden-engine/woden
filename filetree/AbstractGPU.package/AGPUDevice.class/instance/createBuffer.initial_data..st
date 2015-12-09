wrappers
createBuffer: description initial_data: initial_data
	| result |
	result := AGPUCBindings createBuffer_device: (self validHandle) description: description initial_data: initial_data.
	^ AGPUBuffer forHandle: result
