wrappers
setAlphaReference: reference
	| result |
	result := AGPUCBindings setAlphaReference_command_list: (self validHandle) reference: reference.
	self checkErrorCode: result
