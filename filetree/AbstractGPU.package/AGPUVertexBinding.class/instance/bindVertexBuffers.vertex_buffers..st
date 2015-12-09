wrappers
bindVertexBuffers: count vertex_buffers: vertex_buffers
	| result |
	result := AGPUCBindings bindVertexBuffers_vertex_binding: (self validHandle) count: count vertex_buffers: vertex_buffers.
	self checkErrorCode: result
