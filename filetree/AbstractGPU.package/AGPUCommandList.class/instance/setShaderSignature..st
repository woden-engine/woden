wrappers
setShaderSignature: signature
	| result |
	result := AGPUCBindings setShaderSignature_command_list: (self validHandle) signature: (self validHandleOf: signature).
	self checkErrorCode: result
