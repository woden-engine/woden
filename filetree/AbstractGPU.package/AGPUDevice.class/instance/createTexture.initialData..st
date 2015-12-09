wrappers
createTexture: description initialData: initialData
	| result |
	result := AGPUCBindings createTexture_device: (self validHandle) description: description initialData: initialData.
	^ AGPUTexture forHandle: result
