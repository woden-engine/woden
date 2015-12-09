wrappers
getDescription: description
	| result |
	result := AGPUCBindings getDescription_texture: (self validHandle) description: description.
	self checkErrorCode: result
