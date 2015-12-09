wrappers
unmapLevel
	| result |
	result := AGPUCBindings unmapLevel_texture: (self validHandle).
	self checkErrorCode: result
