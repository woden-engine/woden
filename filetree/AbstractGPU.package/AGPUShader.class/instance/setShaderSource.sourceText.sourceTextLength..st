wrappers
setShaderSource: language sourceText: sourceText sourceTextLength: sourceTextLength
	| result |
	result := AGPUCBindings setShaderSource_shader: (self validHandle) language: language sourceText: sourceText sourceTextLength: sourceTextLength.
	self checkErrorCode: result
