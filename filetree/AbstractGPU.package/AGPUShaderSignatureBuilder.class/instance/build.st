wrappers
build
	| result |
	result := AGPUCBindings build_shader_signature_builder: (self validHandle).
	^ AGPUShaderSignature forHandle: result
