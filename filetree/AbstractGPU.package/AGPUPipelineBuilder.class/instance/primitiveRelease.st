wrappers
primitiveRelease
	| result |
	result := AGPUCBindings release_pipeline_builder: (self validHandle).
	self checkErrorCode: result
