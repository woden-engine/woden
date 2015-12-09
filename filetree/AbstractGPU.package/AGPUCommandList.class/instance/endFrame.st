wrappers
endFrame
	| result |
	result := AGPUCBindings endFrame_command_list: (self validHandle).
	self checkErrorCode: result
