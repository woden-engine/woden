wrappers
attachDepthStencilBuffer: buffer
	| result |
	result := AGPUCBindings attachDepthStencilBuffer_framebuffer: (self validHandle) buffer: (self validHandleOf: buffer).
	self checkErrorCode: result
