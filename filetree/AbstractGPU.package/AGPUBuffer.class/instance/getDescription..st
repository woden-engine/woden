wrappers
getDescription: description
	| result |
	result := AGPUCBindings getDescription_buffer: (self validHandle) description: description.
	self checkErrorCode: result
