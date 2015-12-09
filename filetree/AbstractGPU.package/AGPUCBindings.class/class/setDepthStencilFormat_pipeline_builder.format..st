pipeline_builder
setDepthStencilFormat_pipeline_builder: pipeline_builder format: format
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_error agpuSetDepthStencilFormat (agpu_pipeline_builder* pipeline_builder , agpu_texture_format format) )
