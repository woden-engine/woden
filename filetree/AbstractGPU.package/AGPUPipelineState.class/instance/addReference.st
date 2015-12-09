wrappers
addReference
	| result |
	result := AGPUCBindings addReference_pipeline_state: (self validHandle).
	self checkErrorCode: result
