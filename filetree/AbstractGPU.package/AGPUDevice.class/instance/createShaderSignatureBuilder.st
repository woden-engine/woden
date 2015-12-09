wrappers
createShaderSignatureBuilder
	| result |
	result := AGPUCBindings createShaderSignatureBuilder_device: (self validHandle).
	^ AGPUShaderSignatureBuilder forHandle: result
