wrappers
createTexture: description
	| result |
	result := AGPUCBindings createTexture_device: (self validHandle) description: description.
	^ AGPUTexture forHandle: result
