wrappers
addReference
	| result |
	result := AGPUCBindings addReference_command_list: (self validHandle).
	self checkErrorCode: result
