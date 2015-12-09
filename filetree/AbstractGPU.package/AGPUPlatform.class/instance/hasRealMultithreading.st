wrappers
hasRealMultithreading
	| result |
	result := AGPUCBindings hasRealMultithreading_platform: (self validHandle).
	^ result
