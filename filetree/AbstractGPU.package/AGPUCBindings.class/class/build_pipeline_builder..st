pipeline_builder
build_pipeline_builder: pipeline_builder
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_pipeline_state* agpuBuildPipelineState (agpu_pipeline_builder* pipeline_builder) )
