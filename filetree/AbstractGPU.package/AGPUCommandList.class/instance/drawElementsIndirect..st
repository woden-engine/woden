wrappers
drawElementsIndirect: offset
	| result |
	result := AGPUCBindings drawElementsIndirect_command_list: (self validHandle) offset: offset.
	self checkErrorCode: result
