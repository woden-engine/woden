wrappers
isNative
	| result |
	result := AGPUCBindings isNative_platform: (self validHandle).
	^ result
