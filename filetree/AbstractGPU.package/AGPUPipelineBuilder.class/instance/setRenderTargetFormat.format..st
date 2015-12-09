wrappers
setRenderTargetFormat: index format: format
	| result |
	result := AGPUCBindings setRenderTargetFormat_pipeline_builder: (self validHandle) index: index format: format.
	self checkErrorCode: result
