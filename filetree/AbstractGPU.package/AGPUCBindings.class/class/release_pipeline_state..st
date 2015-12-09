pipeline_state
release_pipeline_state: pipeline_state
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_error agpuReleasePipelineState (agpu_pipeline_state* pipeline_state) )
