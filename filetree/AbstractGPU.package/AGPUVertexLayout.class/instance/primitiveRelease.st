wrappers
primitiveRelease
	| result |
	result := AGPUCBindings release_vertex_layout: (self validHandle).
	self checkErrorCode: result
