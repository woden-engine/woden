wrappers
addVertexAttributeBindings: vertex_buffer_count attribute_count: attribute_count attributes: attributes
	| result |
	result := AGPUCBindings addVertexAttributeBindings_vertex_layout: (self validHandle) vertex_buffer_count: vertex_buffer_count attribute_count: attribute_count attributes: attributes.
	self checkErrorCode: result
