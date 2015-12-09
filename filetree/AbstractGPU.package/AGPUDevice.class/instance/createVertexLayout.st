wrappers
createVertexLayout
	| result |
	result := AGPUCBindings createVertexLayout_device: (self validHandle).
	^ AGPUVertexLayout forHandle: result
