wrappers
setDepthStencilFormat: format
	| result |
	result := AGPUCBindings setDepthStencilFormat_pipeline_builder: (self validHandle) format: format.
	self checkErrorCode: result
