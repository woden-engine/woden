wrappers
bindAttributeLocation: name location: location
	| result |
	result := AGPUCBindings bindAttributeLocation_shader: (self validHandle) name: name location: location.
	self checkErrorCode: result
