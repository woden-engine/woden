wrappers
readBufferData: offset size: size data: data
	| result |
	result := AGPUCBindings readBufferData_buffer: (self validHandle) offset: offset size: size data: data.
	self checkErrorCode: result
