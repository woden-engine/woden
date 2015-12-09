wrappers
addReference
	| result |
	result := AGPUCBindings addReference_pipeline_builder: (self validHandle).
	self checkErrorCode: result
