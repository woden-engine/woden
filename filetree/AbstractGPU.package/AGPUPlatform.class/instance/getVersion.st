wrappers
getVersion
	| result |
	result := AGPUCBindings getVersion_platform: (self validHandle).
	^ result
