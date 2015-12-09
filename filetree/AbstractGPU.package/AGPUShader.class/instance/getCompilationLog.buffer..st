wrappers
getCompilationLog: buffer_size buffer: buffer
	| result |
	result := AGPUCBindings getCompilationLog_shader: (self validHandle) buffer_size: buffer_size buffer: buffer.
	self checkErrorCode: result
