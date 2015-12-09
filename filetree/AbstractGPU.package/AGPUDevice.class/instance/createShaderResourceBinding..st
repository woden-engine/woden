wrappers
createShaderResourceBinding: bindingBank
	| result |
	result := AGPUCBindings createShaderResourceBinding_device: (self validHandle) bindingBank: bindingBank.
	^ AGPUShaderResourceBinding forHandle: result
