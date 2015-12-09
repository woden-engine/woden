wrappers
finishExecution
	| result |
	result := AGPUCBindings finishExecution_command_queue: (self validHandle).
	self checkErrorCode: result
