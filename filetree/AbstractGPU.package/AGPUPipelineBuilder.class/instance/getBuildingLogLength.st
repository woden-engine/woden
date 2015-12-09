wrappers
getBuildingLogLength
	| result |
	result := AGPUCBindings getBuildingLogLength_pipeline_builder: (self validHandle).
	^ result
