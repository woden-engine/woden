wrappers
useIndexBuffer: index_buffer
	| result |
	result := AGPUCBindings useIndexBuffer_command_list: (self validHandle) index_buffer: (self validHandleOf: index_buffer).
	self checkErrorCode: result
