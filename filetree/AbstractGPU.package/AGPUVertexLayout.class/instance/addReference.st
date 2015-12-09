wrappers
addReference
	| result |
	result := AGPUCBindings addReference_vertex_layout: (self validHandle).
	self checkErrorCode: result
