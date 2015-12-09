pipeline_builder
setRenderTargetFormat_pipeline_builder: pipeline_builder index: index format: format
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_error agpuSetRenderTargetFormat (agpu_pipeline_builder* pipeline_builder , agpu_uint index , agpu_texture_format format) )
