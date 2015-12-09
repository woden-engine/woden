wrappers
bindUniformBuffer: location uniform_buffer: uniform_buffer
	| result |
	result := AGPUCBindings bindUniformBuffer_shader_resource_binding: (self validHandle) location: location uniform_buffer: (self validHandleOf: uniform_buffer).
	self checkErrorCode: result
