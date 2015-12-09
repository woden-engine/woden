wrappers
getPreferredHighLevelShaderLanguage
	| result |
	result := AGPUCBindings getPreferredHighLevelShaderLanguage_device: (self validHandle).
	^ result
