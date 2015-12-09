pipeline_builder
setRenderTargetCount_pipeline_builder: pipeline_builder count: count
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_error agpuSetRenderTargetCount (agpu_pipeline_builder* pipeline_builder , agpu_int count) )
