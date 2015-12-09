wrappers
addReference
	| result |
	result := AGPUCBindings addReference_vertex_binding: (self validHandle).
	self checkErrorCode: result
