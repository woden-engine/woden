wrappers
mapBuffer: flags
	| result |
	result := AGPUCBindings mapBuffer_buffer: (self validHandle) flags: flags.
	^ result
