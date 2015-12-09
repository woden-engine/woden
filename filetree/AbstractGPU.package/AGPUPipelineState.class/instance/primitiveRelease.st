wrappers
primitiveRelease
	| result |
	result := AGPUCBindings release_pipeline_state: (self validHandle).
	self checkErrorCode: result
