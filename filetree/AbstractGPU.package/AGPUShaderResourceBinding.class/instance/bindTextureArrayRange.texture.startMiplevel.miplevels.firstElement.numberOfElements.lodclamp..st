wrappers
bindTextureArrayRange: location texture: texture startMiplevel: startMiplevel miplevels: miplevels firstElement: firstElement numberOfElements: numberOfElements lodclamp: lodclamp
	| result |
	result := AGPUCBindings bindTextureArrayRange_shader_resource_binding: (self validHandle) location: location texture: (self validHandleOf: texture) startMiplevel: startMiplevel miplevels: miplevels firstElement: firstElement numberOfElements: numberOfElements lodclamp: lodclamp.
	self checkErrorCode: result
