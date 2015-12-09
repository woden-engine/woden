wrappers
useShaderResources: binding
	| result |
	result := AGPUCBindings useShaderResources_command_list: (self validHandle) binding: (self validHandleOf: binding).
	self checkErrorCode: result
