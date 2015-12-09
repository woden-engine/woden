wrappers
getBuildingLog: buffer_size buffer: buffer
	| result |
	result := AGPUCBindings getBuildingLog_pipeline_builder: (self validHandle) buffer_size: buffer_size buffer: buffer.
	self checkErrorCode: result
