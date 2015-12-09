wrappers
attachColorBuffer: index buffer: buffer
	| result |
	result := AGPUCBindings attachColorBuffer_framebuffer: (self validHandle) index: index buffer: (self validHandleOf: buffer).
	self checkErrorCode: result
