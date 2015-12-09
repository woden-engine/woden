wrappers
setStencilReference: reference
	| result |
	result := AGPUCBindings setStencilReference_command_list: (self validHandle) reference: reference.
	self checkErrorCode: result
