wrappers
addBindingBank: type bindingPointCount: bindingPointCount maxBindings: maxBindings
	| result |
	result := AGPUCBindings addBindingBank_shader_signature_builder: (self validHandle) type: type bindingPointCount: bindingPointCount maxBindings: maxBindings.
	self checkErrorCode: result
