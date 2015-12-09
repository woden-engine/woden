wrappers
build
	| result |
	result := AGPUCBindings build_pipeline_builder: (self validHandle).
	^ AGPUPipelineState forHandle: result
