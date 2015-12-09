wrappers
setViewport: x y: y w: w h: h
	| result |
	result := AGPUCBindings setViewport_command_list: (self validHandle) x: x y: y w: w h: h.
	self checkErrorCode: result
