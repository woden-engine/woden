wrappers
bindTexture: location texture: texture startMiplevel: startMiplevel miplevels: miplevels lodclamp: lodclamp
	| result |
	result := AGPUCBindings bindTexture_shader_resource_binding: (self validHandle) location: location texture: (self validHandleOf: texture) startMiplevel: startMiplevel miplevels: miplevels lodclamp: lodclamp.
	self checkErrorCode: result
