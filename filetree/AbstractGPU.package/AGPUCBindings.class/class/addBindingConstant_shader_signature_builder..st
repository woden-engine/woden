shader_signature_builder
addBindingConstant_shader_signature_builder: shader_signature_builder
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin error: errorCode>
	^ self nbCall: #(agpu_error agpuAddShaderSignatureBindingConstant (agpu_shader_signature_builder* shader_signature_builder) )
