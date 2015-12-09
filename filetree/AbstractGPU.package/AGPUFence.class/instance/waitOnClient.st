wrappers
waitOnClient
	| result |
	result := AGPUCBindings waitOnClient_fence: (self validHandle).
	self checkErrorCode: result
