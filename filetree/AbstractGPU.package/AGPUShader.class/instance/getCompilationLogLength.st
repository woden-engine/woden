wrappers
getCompilationLogLength
	| result |
	result := AGPUCBindings getCompilationLogLength_shader: (self validHandle).
	^ result
