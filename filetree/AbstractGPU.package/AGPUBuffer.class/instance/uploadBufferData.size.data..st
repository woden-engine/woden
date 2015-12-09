wrappers
uploadBufferData: offset size: size data: data
	| result |
	result := AGPUCBindings uploadBufferData_buffer: (self validHandle) offset: offset size: size data: data.
	self checkErrorCode: result
