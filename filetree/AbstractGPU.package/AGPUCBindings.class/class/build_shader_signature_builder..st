shader_signature_builder
build_shader_signature_builder: shader_signature_builder
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_shader_signature* agpuBuildShaderSignature (agpu_shader_signature_builder* shader_signature_builder) )
