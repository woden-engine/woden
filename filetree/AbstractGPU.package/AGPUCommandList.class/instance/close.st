wrappers
close
	| result |
	result := AGPUCBindings close_command_list: (self validHandle).
	self checkErrorCode: result
