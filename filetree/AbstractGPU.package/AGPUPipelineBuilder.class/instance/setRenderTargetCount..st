wrappers
setRenderTargetCount: count
	| result |
	result := AGPUCBindings setRenderTargetCount_pipeline_builder: (self validHandle) count: count.
	self checkErrorCode: result
