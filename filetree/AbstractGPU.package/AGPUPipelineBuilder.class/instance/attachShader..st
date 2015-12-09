wrappers
attachShader: shader
	| result |
	result := AGPUCBindings attachShader_pipeline_builder: (self validHandle) shader: (self validHandleOf: shader).
	self checkErrorCode: result
