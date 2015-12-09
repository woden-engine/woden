wrappers
setClearColor: r g: g b: b a: a
	| result |
	result := AGPUCBindings setClearColor_command_list: (self validHandle) r: r g: g b: b a: a.
	self checkErrorCode: result
