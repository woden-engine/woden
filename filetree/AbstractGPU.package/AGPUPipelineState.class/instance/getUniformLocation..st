wrappers
getUniformLocation: name
	| result |
	result := AGPUCBindings getUniformLocation_pipeline_state: (self validHandle) name: name.
	^ result
