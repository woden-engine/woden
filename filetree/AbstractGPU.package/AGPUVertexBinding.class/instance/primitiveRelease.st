wrappers
primitiveRelease
	| result |
	result := AGPUCBindings release_vertex_binding: (self validHandle).
	self checkErrorCode: result
