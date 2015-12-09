wrappers
unmapBuffer
	| result |
	result := AGPUCBindings unmapBuffer_buffer: (self validHandle).
	self checkErrorCode: result
