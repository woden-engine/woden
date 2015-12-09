wrappers
setShaderSignature: signature
	| result |
	result := AGPUCBindings setShaderSignature_pipeline_builder: (self validHandle) signature: (self validHandleOf: signature).
	self checkErrorCode: result
