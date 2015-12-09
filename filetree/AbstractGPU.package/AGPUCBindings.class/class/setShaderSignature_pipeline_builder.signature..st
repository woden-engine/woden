pipeline_builder
setShaderSignature_pipeline_builder: pipeline_builder signature: signature
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_error agpuSetPipelineShaderSignature (agpu_pipeline_builder* pipeline_builder , agpu_shader_signature* signature) )
