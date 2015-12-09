wrappers
bindUniformBufferRange: location uniform_buffer: uniform_buffer offset: offset size: size
	| result |
	result := AGPUCBindings bindUniformBufferRange_shader_resource_binding: (self validHandle) location: location uniform_buffer: (self validHandleOf: uniform_buffer) offset: offset size: size.
	self checkErrorCode: result
