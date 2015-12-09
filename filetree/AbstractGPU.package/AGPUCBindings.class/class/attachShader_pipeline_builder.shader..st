pipeline_builder
attachShader_pipeline_builder: pipeline_builder shader: shader
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_error agpuAttachShader (agpu_pipeline_builder* pipeline_builder , agpu_shader* shader) )
