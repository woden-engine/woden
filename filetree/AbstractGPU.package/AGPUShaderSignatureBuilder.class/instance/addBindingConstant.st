wrappers
addBindingConstant
	| result |
	result := AGPUCBindings addBindingConstant_shader_signature_builder: (self validHandle).
	self checkErrorCode: result
