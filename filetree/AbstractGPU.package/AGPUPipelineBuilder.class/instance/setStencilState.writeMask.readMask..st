wrappers
setStencilState: enabled writeMask: writeMask readMask: readMask
	| result |
	result := AGPUCBindings setStencilState_pipeline_builder: (self validHandle) enabled: enabled writeMask: writeMask readMask: readMask.
	self checkErrorCode: result
