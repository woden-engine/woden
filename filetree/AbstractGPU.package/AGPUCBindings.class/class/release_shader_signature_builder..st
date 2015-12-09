shader_signature_builder
release_shader_signature_builder: shader_signature_builder
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_error agpuReleaseShaderSignatureBuilder (agpu_shader_signature_builder* shader_signature_builder) )
