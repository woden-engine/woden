pipeline_builder
addReference_pipeline_builder: pipeline_builder
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_error agpuAddPipelineBuilderReference (agpu_pipeline_builder* pipeline_builder) )
