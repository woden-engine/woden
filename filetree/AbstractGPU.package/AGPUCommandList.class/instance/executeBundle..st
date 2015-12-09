wrappers
executeBundle: bundle
	| result |
	result := AGPUCBindings executeBundle_command_list: (self validHandle) bundle: (self validHandleOf: bundle).
	self checkErrorCode: result
