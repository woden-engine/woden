wrappers
createShaderResourceBinding: element
	| result |
	result := AGPUCBindings createShaderResourceBinding_shader_signature: (self validHandle) element: element.
	^ AGPUShaderResourceBinding forHandle: result
