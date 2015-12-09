wrappers
getName
	| result |
	result := AGPUCBindings getName_platform: (self validHandle).
	^ result
