pipeline_builder
release_pipeline_builder: pipeline_builder
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_error agpuReleasePipelineBuilder (agpu_pipeline_builder* pipeline_builder) )
