pipeline_state
addReference_pipeline_state: pipeline_state
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_error agpuAddPipelineStateReference (agpu_pipeline_state* pipeline_state) )
