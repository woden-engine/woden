wrappers
setPrimitiveType: type
	| result |
	result := AGPUCBindings setPrimitiveType_pipeline_builder: (self validHandle) type: type.
	self checkErrorCode: result
