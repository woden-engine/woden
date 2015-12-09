wrappers
waitFence: fence
	| result |
	result := AGPUCBindings waitFence_command_queue: (self validHandle) fence: (self validHandleOf: fence).
	self checkErrorCode: result
