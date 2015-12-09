wrappers
discardUploadBuffer
	| result |
	result := AGPUCBindings discardUploadBuffer_texture: (self validHandle).
	self checkErrorCode: result
