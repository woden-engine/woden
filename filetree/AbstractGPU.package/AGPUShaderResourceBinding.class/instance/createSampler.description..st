wrappers
createSampler: location description: description
	| result |
	result := AGPUCBindings createSampler_shader_resource_binding: (self validHandle) location: location description: description.
	self checkErrorCode: result
