wrappers
setClearStencil: value
	| result |
	result := AGPUCBindings setClearStencil_command_list: (self validHandle) value: value.
	self checkErrorCode: result
