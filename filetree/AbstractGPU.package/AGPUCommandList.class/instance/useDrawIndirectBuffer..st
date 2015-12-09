wrappers
useDrawIndirectBuffer: draw_buffer
	| result |
	result := AGPUCBindings useDrawIndirectBuffer_command_list: (self validHandle) draw_buffer: (self validHandleOf: draw_buffer).
	self checkErrorCode: result
