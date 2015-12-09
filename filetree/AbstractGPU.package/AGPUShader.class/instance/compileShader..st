wrappers
compileShader: options
	| result |
	result := AGPUCBindings compileShader_shader: (self validHandle) options: options.
	self checkErrorCode: result
