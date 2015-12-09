shader_signature_builder
addReference_shader_signature_builder: shader_signature_builder
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_error agpuAddShaderSignatureBuilderReference (agpu_shader_signature_builder* shader_signature_builder) )
