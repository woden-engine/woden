wrappers
addBindingElement: type maxBindings: maxBindings
	| result |
	result := AGPUCBindings addBindingElement_shader_signature_builder: (self validHandle) type: type maxBindings: maxBindings.
	self checkErrorCode: result
