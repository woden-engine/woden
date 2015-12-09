wrappers
discardReadbackBuffer
	| result |
	result := AGPUCBindings discardReadbackBuffer_texture: (self validHandle).
	self checkErrorCode: result
