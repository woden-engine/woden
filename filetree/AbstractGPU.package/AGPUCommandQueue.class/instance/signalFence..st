wrappers
signalFence: fence
	| result |
	result := AGPUCBindings signalFence_command_queue: (self validHandle) fence: (self validHandleOf: fence).
	self checkErrorCode: result
