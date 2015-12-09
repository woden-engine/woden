wrappers
getPreferredShaderLanguage
	| result |
	result := AGPUCBindings getPreferredShaderLanguage_device: (self validHandle).
	^ result
