wrappers
setDepthState: enabled writeMask: writeMask function: function
	| result |
	result := AGPUCBindings setDepthState_pipeline_builder: (self validHandle) enabled: enabled writeMask: writeMask function: function.
	self checkErrorCode: result
