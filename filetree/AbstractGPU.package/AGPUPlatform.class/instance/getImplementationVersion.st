wrappers
getImplementationVersion
	| result |
	result := AGPUCBindings getImplementationVersion_platform: (self validHandle).
	^ result
