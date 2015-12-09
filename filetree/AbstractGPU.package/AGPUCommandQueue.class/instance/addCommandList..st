wrappers
addCommandList: command_list
	| result |
	result := AGPUCBindings addCommandList_command_queue: (self validHandle) command_list: (self validHandleOf: command_list).
	self checkErrorCode: result
