wrappers
beginFrame: framebuffer
	| result |
	result := AGPUCBindings beginFrame_command_list: (self validHandle) framebuffer: (self validHandleOf: framebuffer).
	self checkErrorCode: result
